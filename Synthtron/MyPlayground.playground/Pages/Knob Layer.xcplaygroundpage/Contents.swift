import UIKit
import PlaygroundSupport

enum DialViewColor {
    case blue
    case green
}

@IBDesignable
class DialView : UIView {
    
//    @IBInspectable var dialColor: DialViewColor = .blue {
//        didSet {
//        }
//    }
    
    private let innerDial = CALayer()
    private let tickLayer = CALayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        layer.addSublayer(innerDial)
        layer.addSublayer(tickLayer)
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
        
        // tick mark
        let x:CGFloat = 0
        let y:CGFloat = 0
        let width:CGFloat = 9
        let height:CGFloat = 33
        var rect = innerDial.frame
        rect.size.width = 3
        rect.size.height = 11
        rect.origin.x = (bounds.size.width / 2.0) - 1.5
        rect.origin.y += 3.0
        tickLayer.frame = rect
        if let tickImage = UIImage(named: "knob_tick_blue") {
            tickLayer.contents = tickImage.cgImage
        }
    }
    
}


let view = UIView(frame: CGRect(x: 0, y:0, width: 52, height: 52))

var rect = view.frame
rect.size.height = rect.size.width
let dialView = DialView(frame: rect)
view.addSubview(dialView)

view.backgroundColor = UIColor(rgb: 0x373946)
view

PlaygroundPage.current.liveView = view
