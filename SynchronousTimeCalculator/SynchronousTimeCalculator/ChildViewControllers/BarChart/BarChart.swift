import UIKit

class BarChartView: UIView {
    private let mainLayer: CALayer = CALayer()
    private let scrollView: UIScrollView = UIScrollView()
    let space: CGFloat = 10.0
    let barHeight: CGFloat = 5.0
    let contentSpace: CGFloat = 300
    
    var dataEntries: [ListeningTime] = [] {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            scrollView.contentSize = CGSize(width: frame.size.width, height:
                barHeight + space * CGFloat(dataEntries.count) + contentSpace)
            mainLayer.frame = CGRect(x: 0, y: 0, width:
                scrollView.contentSize.width, height:
                scrollView.contentSize.height)
            for i in 0..<dataEntries.count {
                showEntry(index: i, entry: dataEntries[i])
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width,
                                  height: frame.size.height)
    }
    
    private func showEntry(index: Int, entry: ListeningTime) {
        let endXPos: CGFloat = translateWidthValueToXPosition(value:
            Float(entry.endTime) / Float(100.0))
        let startXPos: CGFloat = translateWidthValueToXPosition(value:
            Float(entry.startTime) / Float(100.0))
        let yPos: CGFloat = space + CGFloat(index) * (barHeight + space)
        drawBar(startXPos: startXPos, endXPos: endXPos, yPos: yPos)
        drawTextValue(xPos: endXPos, yPos: yPos, textValue: "\(String(format: "%.1f", entry.endTime-entry.startTime))sec")
    }
    
    private func drawBar(startXPos: CGFloat, endXPos: CGFloat, yPos: CGFloat) {
        let barLayer = CALayer()
        barLayer.frame = CGRect(x: startXPos, y: yPos, width: endXPos, height: barHeight)
        barLayer.backgroundColor = UIColor.red.cgColor
        mainLayer.addSublayer(barLayer)
    }

    private func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String) {
        let font = UIFont.systemFont(ofSize: 14)
        let stringBoundingBox = textValue.size(withAttributes: [NSAttributedString.Key.font: font])
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: stringBoundingBox.width+10, height: stringBoundingBox.height)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(font.fontName as CFString, 0, nil)
        textLayer.fontSize = 10
        textLayer.string = textValue
        mainLayer.addSublayer(textLayer)
    }
    
    private func translateWidthValueToXPosition(value: Float) -> CGFloat {
        let width = CGFloat(value) * (mainLayer.frame.width - space)
        return abs(width)
    }
}
