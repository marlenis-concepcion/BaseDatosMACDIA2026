import Foundation
import AppKit
import CoreText

let scriptDir = FileManager.default.currentDirectoryPath
let inputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "\(scriptDir)/Marlenis-Concepcion-INF8236-Tarea-5.1-Respuestas-y-Evidencias.md"
let outputPDF = CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "\(scriptDir)/Marlenis-Concepcion-INF8236-Tarea-5.1-Respuestas-y-Evidencias.pdf"
let logoPath = CommandLine.arguments.count > 3 ? CommandLine.arguments[3] : "\(scriptDir)/../uasd_logo.jpg"

let pageWidth: CGFloat = 612
let pageHeight: CGFloat = 792
let marginLeft: CGFloat = 72
let marginRight: CGFloat = 72
let marginTop: CGFloat = 72
let marginBottom: CGFloat = 72
let contentWidth: CGFloat = pageWidth - marginLeft - marginRight

func makeFont(primary: String, fallback: String, size: CGFloat) -> NSFont {
    if let font = NSFont(name: primary, size: size) {
        return font
    }
    if let font = NSFont(name: fallback, size: size) {
        return font
    }
    return NSFont.systemFont(ofSize: size)
}

let titleFont = makeFont(primary: "Times New Roman Bold", fallback: "Times-Bold", size: 16)
let h1Font = makeFont(primary: "Times New Roman Bold", fallback: "Times-Bold", size: 13)
let h2Font = makeFont(primary: "Times New Roman Bold", fallback: "Times-Bold", size: 12)
let bodyFont = makeFont(primary: "Times New Roman", fallback: "Times-Roman", size: 12)
let monoFont = makeFont(primary: "Menlo", fallback: "Courier", size: 9.5)
let smallFont = makeFont(primary: "Times New Roman", fallback: "Times-Roman", size: 10)

func attrs(font: NSFont) -> [NSAttributedString.Key: Any] {
    [
        .font: font,
        .foregroundColor: NSColor.black
    ]
}

func measure(_ text: String, font: NSFont) -> CGFloat {
    (text as NSString).size(withAttributes: attrs(font: font)).width
}

func wrapText(_ text: String, font: NSFont, width: CGFloat) -> [String] {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.isEmpty {
        return [""]
    }

    var lines: [String] = []
    var current = ""

    for word in trimmed.split(separator: " ", omittingEmptySubsequences: true).map(String.init) {
        let candidate = current.isEmpty ? word : current + " " + word
        if measure(candidate, font: font) <= width {
            current = candidate
        } else {
            if !current.isEmpty {
                lines.append(current)
            }
            current = word
        }
    }

    if !current.isEmpty {
        lines.append(current)
    }

    return lines
}

func wrapFixed(_ text: String, font: NSFont, width: CGFloat) -> [String] {
    if text.isEmpty {
        return [""]
    }

    var lines: [String] = []
    var current = ""

    for char in text {
        let candidate = current + String(char)
        if measure(candidate, font: font) <= width {
            current = candidate
        } else {
            lines.append(current)
            current = String(char)
        }
    }

    if !current.isEmpty {
        lines.append(current)
    }

    return lines
}

let outputURL = URL(fileURLWithPath: outputPDF)
var mediaBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

guard let consumer = CGDataConsumer(url: outputURL as CFURL),
      let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
    fatalError("No se pudo crear el PDF")
}

var currentPage = 0
var currentY = marginTop
var pageStarted = false
var logoDrawn = false

func drawLine(_ text: String, x: CGFloat, yFromTop: CGFloat, font: NSFont) {
    let attributed = NSAttributedString(string: text, attributes: attrs(font: font))
    let line = CTLineCreateWithAttributedString(attributed)
    context.textPosition = CGPoint(x: x, y: pageHeight - yFromTop - font.ascender)
    CTLineDraw(line, context)
}

func drawCenteredLine(_ text: String, yFromTop: CGFloat, font: NSFont) {
    let width = measure(text, font: font)
    drawLine(text, x: (pageWidth - width) / 2, yFromTop: yFromTop, font: font)
}

func drawPageNumber(_ number: Int) {
    let text = "\(number)"
    let width = measure(text, font: smallFont)
    drawLine(text, x: pageWidth - marginRight - width, yFromTop: 28, font: smallFont)
}

func drawLogoIfNeeded() {
    if logoDrawn { return }
    let logoURL = URL(fileURLWithPath: logoPath)
    guard let image = NSImage(contentsOf: logoURL) else { return }
    var imageRect = CGRect(origin: .zero, size: image.size)
    guard let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else { return }

    let width: CGFloat = 72
    let height: CGFloat = 72
    let x = (pageWidth - width) / 2
    let y = pageHeight - currentY - height
    context.draw(cgImage, in: CGRect(x: x, y: y, width: width, height: height))
    currentY += height + 18
    logoDrawn = true
}

func beginPage() {
    if pageStarted {
        context.endPDFPage()
    }
    currentPage += 1
    context.beginPDFPage(nil)
    drawPageNumber(currentPage)
    currentY = marginTop
    pageStarted = true
}

func finish() {
    if pageStarted {
        context.endPDFPage()
    }
    context.closePDF()
}

func ensureSpace(_ amount: CGFloat) {
    if currentY + amount > pageHeight - marginBottom {
        beginPage()
    }
}

func addSpace(_ amount: CGFloat) {
    currentY += amount
}

func drawParagraph(_ text: String, font: NSFont = bodyFont, indent: CGFloat = 0, spacingAfter: CGFloat = 8) {
    let width = contentWidth - indent
    let lines = wrapText(text, font: font, width: width)
    let lineHeight = font.pointSize * 2.0

    for line in lines {
        ensureSpace(lineHeight)
        drawLine(line, x: marginLeft + indent, yFromTop: currentY, font: font)
        currentY += lineHeight
    }

    currentY += spacingAfter
}

func drawHangingParagraph(_ text: String, font: NSFont = bodyFont, hangingIndent: CGFloat = 24, spacingAfter: CGFloat = 8) {
    let lines = wrapText(text, font: font, width: contentWidth)
    let lineHeight = font.pointSize * 2.0

    for (index, line) in lines.enumerated() {
        ensureSpace(lineHeight)
        let x = index == 0 ? marginLeft : marginLeft + hangingIndent
        drawLine(line, x: x, yFromTop: currentY, font: font)
        currentY += lineHeight
    }

    currentY += spacingAfter
}

func drawPreformatted(_ text: String, spacingAfter: CGFloat = 8) {
    let lines = text.components(separatedBy: "\n")
    let lineHeight = monoFont.pointSize * 1.55

    var allWrapped: [String] = []
    for rawLine in lines {
        allWrapped.append(contentsOf: wrapFixed(rawLine, font: monoFont, width: contentWidth - 20))
    }

    let boxHeight = CGFloat(max(allWrapped.count, 1)) * lineHeight + 14
    ensureSpace(boxHeight + spacingAfter)

    let boxRect = CGRect(
        x: marginLeft,
        y: pageHeight - currentY - boxHeight,
        width: contentWidth,
        height: boxHeight
    )

    context.saveGState()
    context.setFillColor(NSColor(calibratedWhite: 0.965, alpha: 1).cgColor)
    context.fill(boxRect)
    context.setStrokeColor(NSColor(calibratedWhite: 0.80, alpha: 1).cgColor)
    context.setLineWidth(0.8)
    context.stroke(boxRect)
    context.restoreGState()

    currentY += 7

    for rawLine in lines {
        let wrapped = wrapFixed(rawLine, font: monoFont, width: contentWidth - 20)
        for line in wrapped {
            ensureSpace(lineHeight)
            drawLine(line, x: marginLeft + 10, yFromTop: currentY, font: monoFont)
            currentY += lineHeight
        }
    }

    currentY += 7
    currentY += spacingAfter
}

func drawHeading(_ text: String, font: NSFont, centered: Bool = false, spacingBefore: CGFloat = 10, spacingAfter: CGFloat = 8) {
    currentY += spacingBefore
    let lineHeight = font.pointSize * 2.0
    ensureSpace(lineHeight + spacingAfter)

    if centered {
        drawCenteredLine(text, yFromTop: currentY, font: font)
    } else {
        drawLine(text, x: marginLeft, yFromTop: currentY, font: font)
    }
    currentY += lineHeight + spacingAfter
}

let content: String
do {
    content = try String(contentsOfFile: inputPath, encoding: .utf8)
} catch {
    fatalError("No se pudo leer el archivo fuente")
}

let lines = content.components(separatedBy: .newlines)
beginPage()
drawLogoIfNeeded()

var inCodeBlock = false
var codeBuffer: [String] = []
var inReferencesSection = false
var seenFirstSection = false
var isFirstTopLevelSection = true

for raw in lines {
    let line = raw.trimmingCharacters(in: .newlines)

    if line == "```" || line == "```sql" || line == "```text" {
        if inCodeBlock {
            drawPreformatted(codeBuffer.joined(separator: "\n"))
            codeBuffer.removeAll()
            inCodeBlock = false
        } else {
            inCodeBlock = true
        }
        continue
    }

    if inCodeBlock {
        codeBuffer.append(raw)
        continue
    }

    if line.hasPrefix("# ") {
        inReferencesSection = false
        drawHeading(String(line.dropFirst(2)), font: titleFont, centered: true, spacingBefore: 0, spacingAfter: 18)
    } else if line.hasPrefix("## ") {
        let heading = String(line.dropFirst(3))
        inReferencesSection = heading == "Referencias"
        seenFirstSection = true
        if isFirstTopLevelSection {
            beginPage()
            isFirstTopLevelSection = false
        } else {
            beginPage()
        }
        drawHeading(heading, font: h1Font, centered: false, spacingBefore: 10, spacingAfter: 6)
    } else if line.hasPrefix("### ") {
        inReferencesSection = false
        drawHeading(String(line.dropFirst(4)), font: h2Font, centered: false, spacingBefore: 8, spacingAfter: 4)
    } else if line.hasPrefix("- ") {
        drawParagraph("• " + String(line.dropFirst(2)), font: bodyFont, indent: 14, spacingAfter: 4)
    } else if line.isEmpty {
        addSpace(4)
    } else {
        if !seenFirstSection {
            let centeredLines = wrapText(line, font: bodyFont, width: contentWidth)
            let lineHeight = bodyFont.pointSize * 2.0
            for item in centeredLines {
                ensureSpace(lineHeight)
                drawCenteredLine(item, yFromTop: currentY, font: bodyFont)
                currentY += lineHeight
            }
            currentY += 4
        } else if inReferencesSection {
            drawHangingParagraph(line, font: bodyFont, hangingIndent: 24, spacingAfter: 6)
        } else {
            drawParagraph(line)
        }
    }
}

if inCodeBlock, !codeBuffer.isEmpty {
    drawPreformatted(codeBuffer.joined(separator: "\n"))
}

finish()
print("PDF generado en \(outputPDF)")
