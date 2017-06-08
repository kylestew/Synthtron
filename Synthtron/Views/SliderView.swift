import UIKit

protocol SliderDelegate: class {
    func sliderValueDidChange(_ value: Double, tag: Int)
}

@IBDesignable
class SliderView: UIControl {
    
    //************************************************************
    // MARK: IBInspectable
    //************************************************************
    
    @IBInspectable var knobRadius: CGFloat = 9.0
    @IBInspectable var trackWidth: CGFloat = 6.0
    
    //************************************************************
    // MARK: Public properties
    //************************************************************
    
    weak var delegate: SliderDelegate?
    
    var minValue: Double = 0.0
    var maxValue: Double = 1.0
    
    // domain: [minValue, maxValue]
    var currentValue = 0.5 {
        didSet {
            // bound by min/max
            currentValue = min(max(currentValue, minValue), maxValue)
            delegate?.sliderValueDidChange(currentValue, tag: self.tag)
            updateView()
        }
    }
    
    //************************************************************
    // MARK: Private properties
    //************************************************************
    
    // domain: unitized [0, 1]
    private var sliderValue:CGFloat {
        get {
            return CGFloat(Rescale(from: (minValue, maxValue), to: (0, 1)).rescale(currentValue))
        }
        set {
            currentValue = Rescale(from: (0, 1), to: (minValue, maxValue)).rescale(Double(newValue))
        }
    }
    
    private let knobLayer = CALayer()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        contentMode = .redraw
        backgroundColor = .clear
        
        knobLayer.frame = CGRect(x: 0, y: 0, width: knobRadius*2.0, height: knobRadius*2.0)
        knobLayer.cornerRadius = knobRadius
        knobLayer.backgroundColor = UIColor(rgb: 0xCCCCCD).cgColor
        knobLayer.shadowOffset = CGSize(width: 0, height: 2)
        knobLayer.shadowRadius = 8.0
        knobLayer.shadowOpacity = 1.0
        layer.addSublayer(knobLayer)
        
        
        // TODO: add inner stuff on knobLayer if yuou can
//        //// Color Declarations
//        let fillColor = UIColor(red: 0.800, green: 0.800, blue: 0.804, alpha: 1.000)
//        let fillColor2 = UIColor(red: 0.901, green: 0.528, blue: 0.099, alpha: 1.000)
//        
//        //// Group 2
//        //// Oval Drawing
//        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 17.5, height: 17.3))
//        fillColor.setFill()
//        ovalPath.fill()
//        
//        
//        //// Oval 2 Drawing
//        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 3.75, y: 3.7, width: 10, height: 9.9))
//        fillColor2.setFill()
//        oval2Path.fill()
//
        
        
        // track relative movement of finger
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognized(_:)))
        addGestureRecognizer(panGesture)
    }
    
    func updateView() {
        CATransaction.begin()
        CATransaction.setDisableActions(true) // don't animate transition or it will lag
        
        // position knob
        var heightRange = bounds.height - knobRadius * 2.0
        heightRange *= 1.0 - sliderValue
        knobLayer.position.y = heightRange + knobRadius
        knobLayer.position.x = round(((bounds.width - trackWidth) / 2.0) + trackWidth / 2.0)
        
        CATransaction.commit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        let fillColor = UIColor(red: 0.122, green: 0.122, blue: 0.137, alpha: 1.000)
        let fillColor2 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let shadowTint = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        let shadow = NSShadow()
        shadow.shadowColor = shadowTint.withAlphaComponent(0.2 * shadowTint.cgColor.alpha)
        shadow.shadowOffset = CGSize(width: 46, height: -1)
        shadow.shadowBlurRadius = 1
        
        // track background
        let trackWidth: CGFloat = 6.0
        let pad: CGFloat = round(knobRadius - trackWidth / 2.0)
        let rect = CGRect(x: round((bounds.width - trackWidth) / 2.0), y: pad, width: trackWidth, height: bounds.height - pad * 2)
        let roundedRectPath = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: trackWidth/2.0, height: trackWidth/2.0))
//        bezierPath.usesEvenOddFillRule = true
        fillColor.setFill()
        roundedRectPath.fill()
        
//        //// Group 3
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        // TODO: inner bevel for track
        
//        //// Clip Clip
//        let clipPath = UIBezierPath()
//        clipPath.move(to: CGPoint(x: 0.25, y: 2.5))
//        clipPath.addCurve(to: CGPoint(x: 2.75, y: 0), controlPoint1: CGPoint(x: 0.25, y: 1.12), controlPoint2: CGPoint(x: 1.36, y: 0))
//        clipPath.addLine(to: CGPoint(x: 2.75, y: 0))
//        clipPath.addCurve(to: CGPoint(x: 5.25, y: 2.5), controlPoint1: CGPoint(x: 4.13, y: 0), controlPoint2: CGPoint(x: 5.25, y: 1.12))
//        clipPath.addLine(to: CGPoint(x: 5.25, y: 71.47))
//        clipPath.addCurve(to: CGPoint(x: 2.75, y: 73.97), controlPoint1: CGPoint(x: 5.25, y: 72.85), controlPoint2: CGPoint(x: 4.14, y: 73.97))
//        clipPath.addLine(to: CGPoint(x: 2.75, y: 73.97))
//        clipPath.addCurve(to: CGPoint(x: 0.25, y: 71.47), controlPoint1: CGPoint(x: 1.37, y: 73.97), controlPoint2: CGPoint(x: 0.25, y: 72.85))
//        clipPath.addLine(to: CGPoint(x: 0.25, y: 2.5))
//        clipPath.close()
//        clipPath.usesEvenOddFillRule = true
//        clipPath.addClip()
//        
//        
//        //// Bezier 2 Drawing
//        let bezier2Path = UIBezierPath()
//        bezier2Path.move(to: CGPoint(x: -53.75, y: -8))
//        bezier2Path.addLine(to: CGPoint(x: -30.75, y: -8))
//        bezier2Path.addLine(to: CGPoint(x: -30.75, y: 83))
//        bezier2Path.addLine(to: CGPoint(x: -53.75, y: 83))
//        bezier2Path.addLine(to: CGPoint(x: -53.75, y: -8))
//        bezier2Path.close()
//        bezier2Path.move(to: CGPoint(x: -45.75, y: 2.5))
//        bezier2Path.addCurve(to: CGPoint(x: -43.25, y: 0), controlPoint1: CGPoint(x: -45.75, y: 1.12), controlPoint2: CGPoint(x: -44.64, y: 0))
//        bezier2Path.addLine(to: CGPoint(x: -43.25, y: 0))
//        bezier2Path.addCurve(to: CGPoint(x: -40.75, y: 2.5), controlPoint1: CGPoint(x: -41.87, y: 0), controlPoint2: CGPoint(x: -40.75, y: 1.12))
//        bezier2Path.addLine(to: CGPoint(x: -40.75, y: 71.47))
//        bezier2Path.addCurve(to: CGPoint(x: -43.25, y: 73.97), controlPoint1: CGPoint(x: -40.75, y: 72.85), controlPoint2: CGPoint(x: -41.86, y: 73.97))
//        bezier2Path.addLine(to: CGPoint(x: -43.25, y: 73.97))
//        bezier2Path.addCurve(to: CGPoint(x: -45.75, y: 71.47), controlPoint1: CGPoint(x: -44.63, y: 73.97), controlPoint2: CGPoint(x: -45.75, y: 72.85))
//        bezier2Path.addLine(to: CGPoint(x: -45.75, y: 2.5))
//        bezier2Path.close()
//        context.saveGState()
//        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
//        bezier2Path.usesEvenOddFillRule = true
//        fillColor2.setFill()
//        bezier2Path.fill()
//        context.restoreGState()
        
        context.endTransparencyLayer()
        context.restoreGState()
        
        // dots
        let dotDistance: CGFloat = 8.0
        let dotCirc: CGFloat = 4.0
        var dotColor = UIColor(rgb: 0xABACAE)
        var dotRect = CGRect(x: floor((bounds.width / 2.0 + trackWidth / 2.0) + dotDistance), y: pad, width: dotCirc, height: dotCirc)
        // top dot
        var dotPath = UIBezierPath(ovalIn: dotRect)
        dotColor.setFill()
        dotPath.fill()
        // bottom dot
        dotRect.origin.y = bounds.height - dotCirc - pad
        dotPath = UIBezierPath(ovalIn: dotRect)
        // 2nd dot is 30% transparent
        dotColor = dotColor.withAlphaComponent(0.3)
        dotColor.setFill()
        dotPath.fill()
    }
    
    //************************************************************
    // MARK: Gesture Recognizer
    //************************************************************
    
    var lastPosition = CGPoint.zero
    var lastValue:CGFloat = 0.0
    func panGestureRecognized(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            lastPosition = knobLayer.position
            lastValue = sliderValue
            
        case .changed:
            // find new potential position
            // only translate in y axis
            var trans = recognizer.translation(in: self)
            trans.x = 0
            let newPos = lastPosition + trans
            
            // calculate based on value
            sliderValue = CGFloat(Rescale(from: (Double(knobRadius), Double(bounds.height - knobRadius)), to: (1, 0)).rescale(Double(newPos.y)))
            
        default:
            break
        }
    }
    
}
