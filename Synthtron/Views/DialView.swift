import UIKit

enum DialViewColor: Int {
    case blue
    case green
}

class DialView : UIView {
    
    var tickColor:DialViewColor? {
        didSet {
            let bundle = Bundle(for: type(of: self))
            switch tickColor! {
            case .blue:
                tickImage = UIImage(named: "knob_tick_blue", in: bundle, compatibleWith: self.traitCollection)!
            case .green:
                tickImage = UIImage(named: "knob_tick_green", in: bundle, compatibleWith: self.traitCollection)!
            }
            layoutSubviews()
        }
    }
    
    var rotation = 0.0 {
        didSet { updateDialRotation() }
    }
    
    private let innerDial = CALayer()
    private let rotatorLayer = CALayer()
    private let tickLayer = CALayer()
    private var tickImage: UIImage?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        layer.addSublayer(innerDial)
        layer.addSublayer(rotatorLayer)
        rotatorLayer.addSublayer(tickLayer)
    }
    
    func updateDialRotation() {
        rotatorLayer.transform = CATransform3DMakeRotation(CGFloat(rotation), 0, 0, 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // outer circle
        backgroundColor = UIColor(rgb: 0xCCCCCD)
        layer.cornerRadius = bounds.size.width / 2.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 1.0
        
        // inner circle: 3/5 radius
        let radius: CGFloat = round((bounds.width * (3.0/5.0)) / 2.0)
        let inset = (bounds.width / 2.0) - radius
        innerDial.frame = self.bounds.insetBy(dx: inset, dy: inset)
        innerDial.backgroundColor = UIColor(rgb: 0xE2E2E2).cgColor
        innerDial.cornerRadius = radius
        innerDial.shadowOffset = CGSize(width: 0, height: 2)
        innerDial.shadowRadius = 8.0
        innerDial.shadowOpacity = 1.0
        
        // inner cicle hidden rotator
        rotatorLayer.transform = CATransform3DIdentity // need to clear transform before resetting frame
        rotatorLayer.frame = innerDial.frame
        
        // tick mark
        var rect = rotatorLayer.bounds
        rect.size.width = 3
        rect.size.height = 11
        rect.origin.x = (rotatorLayer.bounds.size.width / 2.0) - 1.5
        rect.origin.y += 4.0
        tickLayer.frame = rect
        tickLayer.contents = tickImage?.cgImage
        
        updateDialRotation()
    }
    
}
