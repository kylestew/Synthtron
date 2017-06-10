import UIKit
import RxSwift

@IBDesignable
class KnobView : UIControl {
    
    var knobValue = Variable(0.0)
    
    @IBInspectable var knobSensitivity: CGFloat = 0.005
    
    @IBInspectable var tickColorIndex: Int = 0 {
        didSet {
            dialView.tickColor = DialViewColor(rawValue: tickColorIndex)
        }
    }
    
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
        
        // track relative movement of finger
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognized(_:)))
        addGestureRecognizer(panGesture)
        
        // update position of knob on next value
        knobValue.asObservable().subscribe(onNext: { [unowned self] nextValue in
            CATransaction.begin()
            CATransaction.setDisableActions(true) // don't animate transition or it will lag
            
            // update rotation of knob
            self.dialView.rotation = Rescale(from: (0, 1), to: (-Double.pi * (4/5.0), Double.pi * (4/5.0))).rescale(Double(nextValue))
//            print("\(nextValue) -> \(self.dialView.rotation)")
            
            CATransaction.commit()
        }).addDisposableTo(disposeBag)
    }
    
    //************************************************************
    // MARK: Gesture Recognizer
    //************************************************************
    
    var lastKnobValue = 0.0
    func panGestureRecognized(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            lastKnobValue = knobValue.value
            
        case .changed:
            // add change in y & x as updated value
            let trans = recognizer.translation(in: self)
            var unitValue = CGFloat(lastKnobValue) + ((trans.x - trans.y) * knobSensitivity)
            
            // bound the value
            unitValue = min(max(unitValue, 0), 1)
            
            // update observable, our UI will move on its own to match value
            knobValue.value = Double(unitValue)
            
        default:
            break
        }
    }
    
}
