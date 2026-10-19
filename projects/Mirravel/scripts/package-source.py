from pathlib import Path
import sys
import zipfile
root = Path(__file__).resolve().parents[1]
output = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'dist/Mirravel-0.1.1-Beta-Quellpaket.zip'
output.parent.mkdir(parents=True, exist_ok=True)
with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED) as archive:
    for path in sorted(root.rglob('*')):
        relative = path.relative_to(root)
        if any(part in {'dist', '.git', '__pycache__', '.DS_Store'} for part in relative.parts):
            continue
        if path.is_symlink():
            raise ValueError('Symlink im Quellpaket: ' + str(relative))
        if path.is_file():
            archive.write(path, Path('Mirravel-0.1.1-Beta') / relative)
with zipfile.ZipFile(output) as archive:
    assert archive.testzip() is None
    for name in ['Mirravel.command', 'DMG_erstellen.command', 'scripts/build-macos.sh']:
        assert (archive.getinfo('Mirravel-0.1.1-Beta/' + name).external_attr >> 16) & 0o111
print('Quellpaket geprüft:', output.name)
