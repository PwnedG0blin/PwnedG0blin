import os
from pathlib import Path
import plistlib
import shlex
import stat
import subprocess
import sys
import tempfile
import unittest

PROJECT = Path(__file__).resolve().parents[1]
DOMAIN = 'OS_ELIGIBILITY_DOMAIN_IRON'


class CoreTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='RegionPilot tests ')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.tools = self.root / 'fake tools'
        self.tools.mkdir()
        self.live = self.root / 'eligibility.plist'
        self.state = self.root / 'state'
        self.flags = self.root / 'flags'
        self.flags.write_text('')
        self.build = self.root / 'build'
        self.build.write_text('TEST-BUILD-A')
        self.marker = self.root / 'work-read'
        self.initial = {DOMAIN: {'os_eligibility_answer_t': 2, 'status': {
            'OS_ELIGIBILITY_INPUT_COUNTRY_BILLING': 2,
            'OS_ELIGIBILITY_INPUT_COUNTRY_LOCATION': 2}, 'untouched': 'preserve'},
            'OTHER_FEATURE': {'enabled': True}}
        self.write(self.initial)
        self.original_bytes = self.live.read_bytes()
        self.env = os.environ | {'RP_LIVE': str(self.live), 'RP_FLAGS': str(self.flags),
                                 'RP_BUILD': str(self.build), 'RP_MARKER': str(self.marker)}
        self.tool('uname', "print('Darwin')")
        self.tool('id', "print('0')")
        self.tool('sw_vers', "print(Path(os.environ['RP_BUILD']).read_text() if '-buildVersion' in sys.argv else '27.2')")
        self.tool('stat', '''
if sys.argv[2] == '%u:%Lp':
    print('0:' + format(stat.S_IMODE(os.stat(sys.argv[3]).st_mode), 'o'))
else:
    print(Path(os.environ['RP_FLAGS']).read_text())
''')
        self.tool('chflags', "Path(os.environ['RP_FLAGS']).write_text('uchg' if sys.argv[1] == 'uchg' else '')")
        self.tool('cat', '''
p = Path(sys.argv[1]); marker = Path(os.environ['RP_MARKER'])
if p.name.startswith('work.'):
    marker.touch()
    if os.environ.get('RP_FAIL_WRITE'):
        sys.stdout.buffer.write(b'incomplete write'); sys.exit(1)
if p.name.startswith('snapshot.') and marker.exists() and os.environ.get('RP_FAIL_ROLLBACK'):
    sys.exit(1)
sys.stdout.buffer.write(p.read_bytes())
''')
        self.tool('plutil', '''
args = sys.argv[1:]; path = Path(args[-1])
try:
    data = plistlib.loads(path.read_bytes())
    if args[0] == '-lint':
        if path.name.startswith('work.') and os.environ.get('RP_RACE'):
            live = Path(os.environ['RP_LIVE']); changed = plistlib.loads(live.read_bytes())
            changed['OTHER_FEATURE']['systemUpdate'] = 'preserve this'
            live.write_bytes(plistlib.dumps(changed))
        if path == Path(os.environ['RP_LIVE']) and Path(os.environ['RP_MARKER']).exists() and os.environ.get('RP_FAIL_VERIFY'):
            sys.exit(1)
        sys.exit(0)
    keys = args[1].split('.'); node = data
    for key in keys[:-1]: node = node[key]
    value = node[keys[-1]]
    if args[0] == '-type':
        print('boolean' if type(value) is bool else 'integer' if type(value) is int else 'string' if type(value) is str else 'dictionary')
    elif args[0] == '-extract': print(value)
    elif args[0] == '-replace':
        node[keys[-1]] = int(args[3]); path.write_bytes(plistlib.dumps(data))
    else: sys.exit(2)
except (OSError, KeyError, ValueError, plistlib.InvalidFileException):
    sys.exit(1)
''')
        source = (PROJECT / 'core.sh').read_text()
        source = source.replace('STATE=/private/var/db/regionpilot', 'STATE=' + shlex.quote(str(self.state)))
        for old in ['/private/var/db/os_eligibility/eligibility.plist', '/private/var/os_eligibility/eligibility.plist']:
            source = source.replace(old, shlex.quote(str(self.live if '/db/' in old else self.root / 'missing.plist')))
        for command in ['plutil', 'stat', 'chflags', 'sw_vers']:
            source = source.replace('/usr/bin/' + command, shlex.quote(str(self.tools / command)))
        source = source.replace('/bin/cat', shlex.quote(str(self.tools / 'cat')))
        source = source.replace('$(uname -s)', '$(' + shlex.quote(str(self.tools / 'uname')) + ' -s)')
        source = source.replace('$(id -u)', '$(' + shlex.quote(str(self.tools / 'id')) + ' -u)')
        assert '/private/var/' not in source, 'A real system path must never survive in test copy'
        self.script = self.root / 'core-under-test.sh'
        self.script.write_text(source)

    def tool(self, name, body):
        p = self.tools / name
        p.write_text('#!' + sys.executable + '\nimport os, sys, stat, plistlib\nfrom pathlib import Path\n' + body + '\n')
        p.chmod(0o700)

    def write(self, data):
        self.live.write_bytes(plistlib.dumps(data))

    def read(self):
        return plistlib.loads(self.live.read_bytes())

    def run_core(self, mode, success=True, **settings):
        result = subprocess.run(['/bin/bash', str(self.script), mode], env=self.env | settings,
                                text=True, capture_output=True, timeout=15)
        if success:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def test_diagnosis_never_changes_data_or_creates_state(self):
        self.run_core('diagnose')
        self.assertEqual(self.live.read_bytes(), self.original_bytes)
        self.assertFalse(self.state.exists())

    def test_patch_changes_only_three_keys_and_saves_original(self):
        self.run_core('apply')
        expected = self.initial
        expected[DOMAIN]['os_eligibility_answer_t'] = 4
        expected[DOMAIN]['status']['OS_ELIGIBILITY_INPUT_COUNTRY_BILLING'] = 3
        expected[DOMAIN]['status']['OS_ELIGIBILITY_INPUT_COUNTRY_LOCATION'] = 3
        self.assertEqual(self.read(), expected)
        self.assertEqual((self.state / 'original.plist').read_bytes(), self.original_bytes)
        self.assertEqual(stat.S_IMODE(self.state.stat().st_mode), 0o700)
        self.assertEqual((self.state / 'active').read_text().strip(), 'applied')
        self.assertFalse((self.state / 'lock').exists())

    def test_restore_keeps_other_new_settings(self):
        self.run_core('apply')
        data = self.read(); data['OTHER_FEATURE']['newSetting'] = 42; self.write(data)
        self.run_core('restore')
        expected = self.initial; expected['OTHER_FEATURE']['newSetting'] = 42
        self.assertEqual(self.read(), expected)
        self.assertFalse((self.state / 'active').exists())

    def test_repeated_apply_does_not_overwrite_original(self):
        self.run_core('apply'); self.run_core('apply')
        self.assertEqual((self.state / 'original.plist').read_bytes(), self.original_bytes)

    def test_missing_key_aborts_before_saving_or_writing(self):
        del self.initial[DOMAIN]['status']['OS_ELIGIBILITY_INPUT_COUNTRY_LOCATION']
        self.write(self.initial); previous = self.live.read_bytes()
        self.run_core('apply', False)
        self.assertEqual(self.live.read_bytes(), previous)
        self.assertFalse(self.state.exists())

    def test_wrong_type_is_rejected(self):
        self.initial[DOMAIN]['os_eligibility_answer_t'] = '2'; self.write(self.initial)
        previous = self.live.read_bytes(); self.run_core('apply', False)
        self.assertEqual(self.live.read_bytes(), previous)

    def test_unknown_value_is_rejected(self):
        self.initial[DOMAIN]['os_eligibility_answer_t'] = 99; self.write(self.initial)
        previous = self.live.read_bytes(); self.run_core('apply', False)
        self.assertEqual(self.live.read_bytes(), previous)

    def test_restore_after_build_change_is_rejected(self):
        self.run_core('apply'); previous = self.live.read_bytes(); self.build.write_text('TEST-BUILD-B')
        self.run_core('restore', False)
        self.assertEqual(self.live.read_bytes(), previous)
        self.assertTrue((self.state / 'active').exists())

    def test_restore_rejects_third_party_change_to_one_of_its_keys(self):
        self.run_core('apply'); data = self.read(); data[DOMAIN]['os_eligibility_answer_t'] = 1; self.write(data)
        previous = self.live.read_bytes(); self.run_core('restore', False)
        self.assertEqual(self.live.read_bytes(), previous)

    def test_state_symlink_is_rejected_without_touching_target(self):
        outside = self.root / 'outside'; outside.mkdir(); self.state.symlink_to(outside, target_is_directory=True)
        self.run_core('apply', False)
        self.assertEqual(self.live.read_bytes(), self.original_bytes)
        self.assertEqual(list(outside.iterdir()), [])

    def test_insecure_state_permissions_are_rejected(self):
        self.state.mkdir(mode=0o755); self.state.chmod(0o755)
        self.run_core('apply', False)
        self.assertEqual(self.live.read_bytes(), self.original_bytes)

    def test_existing_lock_prevents_parallel_patch(self):
        self.state.mkdir(mode=0o700); (self.state / 'lock').mkdir()
        self.run_core('apply', False)
        self.assertEqual(self.live.read_bytes(), self.original_bytes)
        self.assertTrue((self.state / 'lock').exists())

    def test_original_file_flag_is_restored_after_patch_and_restore(self):
        self.flags.write_text('uchg'); self.run_core('apply')
        self.assertEqual(self.flags.read_text(), 'uchg')
        self.run_core('restore'); self.assertEqual(self.flags.read_text(), 'uchg')

    def test_verification_failure_restores_snapshot_and_original_flag(self):
        self.flags.write_text('uchg'); self.run_core('apply', False, RP_FAIL_VERIFY='1')
        self.assertEqual(self.live.read_bytes(), self.original_bytes)
        self.assertEqual(self.flags.read_text(), 'uchg')
        self.assertFalse((self.state / 'lock').exists())

    def test_concurrent_system_change_is_not_overwritten(self):
        self.run_core('apply', False, RP_RACE='1')
        self.assertEqual(self.read()['OTHER_FEATURE']['systemUpdate'], 'preserve this')
        self.assertEqual(self.read()[DOMAIN]['os_eligibility_answer_t'], 2)

    def test_failed_rollback_preserves_recovery_snapshot(self):
        result = self.run_core('apply', False, RP_FAIL_WRITE='1', RP_FAIL_ROLLBACK='1')
        snapshots = list(self.state.glob('snapshot.*'))
        self.assertEqual(len(snapshots), 1)
        self.assertEqual(snapshots[0].read_bytes(), self.original_bytes)
        self.assertIn(str(snapshots[0]), result.stderr)

    def test_unknown_immutable_flag_aborts_before_write(self):
        self.flags.write_text('schg'); self.run_core('apply', False)
        self.assertEqual(self.live.read_bytes(), self.original_bytes)
        self.assertEqual(self.flags.read_text(), 'schg')


if __name__ == '__main__':
    unittest.main()
