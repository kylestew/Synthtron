import UIKit
import RxSwift

@IBDesignable
class KnobView : UIControl {
    
    var knobValue = Variable(0.0)
    
    private let disposeBag = DisposeBag()
    
    private let dialView = DialView()
    
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
        layer.sublayers = nil
        backgroundColor = .clear
        
        // dots
        let dotCirc: CGFloat = 4.0
        let dotColor = UIColor(rgb: 0xABACAE)
        
        let dotMin = CALayer()
        dotMin.frame = CGRect(x: 0, y: bounds.height - dotCirc, width: dotCirc, height: dotCirc)
        dotMin.backgroundColor = dotColor.withAlphaComponent(0.3).cgColor
        dotMin.cornerRadius = dotCirc / 2.0
        layer.addSublayer(dotMin)
        
        let dotMax = CALayer()
        dotMax.frame = CGRect(x: bounds.width - dotCirc, y: bounds.height - dotCirc, width: dotCirc, height: dotCirc)
        dotMax.backgroundColor = dotColor.cgColor
        dotMax.cornerRadius = dotCirc / 2.0
        layer.addSublayer(dotMax)
        
        // add dial view
        let circ = bounds.width
        dialView.frame = CGRect(x: 0, y: 0, width: circ, height: circ)
        addSubview(dialView)
    }
    
}
