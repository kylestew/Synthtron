import UIKit

class DialView : UIView {
    
    let innerDial = CALayer()
    
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
        
        
    }
    
    
}
