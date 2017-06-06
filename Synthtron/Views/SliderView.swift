import UIKit

@IBDesignable
class SliderView: UIView {
    
    @IBInspectable var knobRadius: CGFloat = 9.0
    @IBInspectable var trackWidth: CGFloat = 6.0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isUserInteractionEnabled = true
        contentMode = .redraw
        backgroundColor = .clear
        
        // TODO: add knob
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        contentMode = .redraw
        backgroundColor = .red
        
        // TODO: add knob
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        contentMode = .scaleAspectFill
        backgroundColor = .clear
        clipsToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        let pad: CGFloat = 2.0
        let fillColor = UIColor(red: 0.122, green: 0.122, blue: 0.137, alpha: 1.000)
        let fillColor2 = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let shadowTint = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        let shadow = NSShadow()
        shadow.shadowColor = shadowTint.withAlphaComponent(0.2 * shadowTint.cgColor.alpha)
        shadow.shadowOffset = CGSize(width: 46, height: -1)
        shadow.shadowBlurRadius = 1
        
        // track background
        // TODO: draw a rounded rectangle in this space
        let trackWidth: CGFloat = 6.0
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
    
}
