import AppKit
import CoreGraphics
import Foundation

func color(_ hex: UInt32, _ alpha: CGFloat = 1) -> NSColor {
    NSColor(calibratedRed: CGFloat((hex >> 16) & 255) / 255,
            green: CGFloat((hex >> 8) & 255) / 255,
            blue: CGFloat(hex & 255) / 255,
            alpha: alpha)
}

func gradient(_ rect: CGRect, start: UInt32, end: UInt32, context: CGContext) {
    guard let g = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                             colors: [color(start).cgColor, color(end).cgColor] as CFArray,
                             locations: [0, 1]) else { return }
    context.drawLinearGradient(g,
        start: CGPoint(x: rect.minX, y: rect.maxY),
        end: CGPoint(x: rect.maxX, y: rect.minY), options: [])
}

func rounded(_ rect: CGRect, radius: CGFloat, fill: NSColor, stroke: NSColor? = nil) {
    let shape = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    fill.setFill(); shape.fill()
    if let stroke { stroke.setStroke(); shape.lineWidth = 2; shape.stroke() }
}

func text(_ message: String, x: CGFloat, y: CGFloat, size: CGFloat, tint: NSColor, bold: Bool = false) {
    let font = bold ? NSFont.systemFont(ofSize: size, weight: .bold) : NSFont.systemFont(ofSize: size)
    (message as NSString).draw(at: NSPoint(x: x, y: y), withAttributes: [
        .font: font, .foregroundColor: tint
    ])
}

func render(_ width: Int, _ height: Int, url: URL, draw: (CGContext) -> Void) throws {
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true,
        isPlanar: false, colorSpaceName: .deviceRGB,
        bytesPerRow: 0, bitsPerPixel: 0
    ), let graphics = NSGraphicsContext(bitmapImageRep: rep) else {
        throw NSError(domain: "ClipShiftArtwork", code: 1)
    }
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = graphics
    let ctx = graphics.cgContext
    ctx.setAllowsAntialiasing(true)
    ctx.setShouldAntialias(true)
    draw(ctx)
    graphics.flushGraphics()
    NSGraphicsContext.restoreGraphicsState()
    guard let png = rep.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "ClipShiftArtwork", code: 2)
    }
    try png.write(to: url)
}

func drawIcon(context ctx: CGContext) {
    let r = CGRect(x: 16, y: 16, width: 992, height: 992)
    ctx.saveGState()
    let clip = CGPath(roundedRect: r, cornerWidth: 235, cornerHeight: 235, transform: nil)
    ctx.addPath(clip); ctx.clip()
    gradient(r, start: 0x06142F, end: 0x0B76F2, context: ctx)
    rounded(CGRect(x: 64, y: 64, width: 896, height: 896), radius: 210,
            fill: color(0x7CBFFF, 0.17), stroke: color(0xC8ECFF, 0.7))
    rounded(CGRect(x: 180, y: 220, width: 664, height: 565), radius: 135,
            fill: color(0x0B64CF, 0.92), stroke: color(0x99E6FF, 0.9))
    rounded(CGRect(x: 180, y: 645, width: 664, height: 140), radius: 32,
            fill: color(0x091F44, 0.96), stroke: color(0xC6EAFF, 0.8))

    ctx.saveGState()
    ctx.beginPath()
    for i in 0..<6 {
        let x = CGFloat(204 + i * 112)
        ctx.move(to: CGPoint(x: x, y: 653))
        ctx.addLine(to: CGPoint(x: x + 60, y: 772))
        ctx.addLine(to: CGPoint(x: x + 103, y: 772))
        ctx.addLine(to: CGPoint(x: x + 43, y: 653))
    }
    ctx.setFillColor(color(0xE9F8FF).cgColor)
    ctx.fillPath()
    ctx.restoreGState()
    let triangle = NSBezierPath()
    triangle.move(to: CGPoint(x: 420, y: 360))
    triangle.line(to: CGPoint(x: 420, y: 590))
    triangle.line(to: CGPoint(x: 615, y: 475))
    triangle.close()
    color(0xF8FCFF).setFill()
    triangle.fill()

    let arrow = NSBezierPath()
    arrow.lineWidth = 31
    arrow.lineCapStyle = .round
    arrow.lineJoinStyle = .round
    arrow.move(to: CGPoint(x: 300, y: 287))
    arrow.curve(to: CGPoint(x: 684, y: 287),
                controlPoint1: CGPoint(x: 395, y: 226),
                controlPoint2: CGPoint(x: 572, y: 227))
    color(0xC4F7FF).setStroke(); arrow.stroke()
    let tip = NSBezierPath()
    tip.lineWidth = 30
    tip.lineCapStyle = .round
    tip.move(to: CGPoint(x: 621, y: 347))
    tip.line(to: CGPoint(x: 697, y: 282))
    tip.line(to: CGPoint(x: 621, y: 224))
    tip.stroke()
    ctx.restoreGState()
    let line = NSBezierPath(roundedRect: r, xRadius: 235, yRadius: 235)
    color(0xA6DAFF, 0.8).setStroke(); line.lineWidth = 11; line.stroke()
}

func drawBackground(context ctx: CGContext) {
    let rect = CGRect(x: 0, y: 0, width: 760, height: 500)
    gradient(rect, start: 0x041027, end: 0x0755B2, context: ctx)
    let wave = NSBezierPath()
    wave.move(to: CGPoint(x: 0, y: 45))
    wave.curve(to: CGPoint(x: 760, y: 130),
               controlPoint1: CGPoint(x: 160, y: 290),
               controlPoint2: CGPoint(x: 510, y: 10))
    wave.lineWidth = 105
    color(0x1A89F3, 0.24).setStroke(); wave.stroke()

    rounded(CGRect(x: 29, y: 26, width: 702, height: 448), radius: 34,
            fill: color(0xB1D4FF, 0.09), stroke: color(0xC5E7FF, 0.47))
    rounded(CGRect(x: 47, y: 48, width: 666, height: 407), radius: 28,
            fill: color(0x040F29, 0.26), stroke: color(0x7AB9FF, 0.31))

    text("ClipShift", x: 64, y: 385, size: 42, tint: color(0xF5FAFF), bold: true)
    text("MOV  →  MP4", x: 66, y: 353, size: 16, tint: color(0xA9E2FF), bold: true)

    // Finder provides the two real icons; draw only a visual conversion cue between them.
    let arrow = NSBezierPath()
    arrow.lineWidth = 10; arrow.lineCapStyle = .round; arrow.lineJoinStyle = .round
    arrow.move(to: CGPoint(x: 341, y: 215))
    arrow.line(to: CGPoint(x: 426, y: 215))
    arrow.move(to: CGPoint(x: 404, y: 234))
    arrow.line(to: CGPoint(x: 426, y: 215))
    arrow.line(to: CGPoint(x: 404, y: 196))
    color(0x52C5FF).setStroke(); arrow.stroke()

    text("Drag ClipShift into Applications", x: 231, y: 104,
         size: 17, tint: color(0xF3FAFF), bold: true)
    text("ClipShift in Programme ziehen", x: 248, y: 79,
         size: 14, tint: color(0xA5CDEB))
    text("Free  •  Local  •  No cloud", x: 295, y: 37,
         size: 12, tint: color(0xB8D7F6))
}

guard CommandLine.arguments.count == 3 else {
    fputs("Usage: swift ClipShiftArtwork.swift icon.png background.png\n", stderr)
    exit(2)
}
try render(1024, 1024, url: URL(fileURLWithPath: CommandLine.arguments[1]), draw: drawIcon)
try render(760, 500, url: URL(fileURLWithPath: CommandLine.arguments[2]), draw: drawBackground)
print("ClipShift artwork generated")
