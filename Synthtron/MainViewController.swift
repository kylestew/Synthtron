import UIKit
import AudioKit

class MainViewController: UIViewController {
    
    let whiteKeyNormalColor = UIColor(rgb: 0xFFFFFF)
    let whiteKeyDownColor = UIColor(rgb: 0xDDDDDD)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let oscillator = AKOscillator()
        oscillator.amplitude = 0.1
        AudioKit.output = oscillator
        AudioKit.start()
        oscillator.start()
    }

    //MARK: - Piano Key Actions
    
    @IBAction func whiteKeyDown(_ sender: UIButton) {
        sender.backgroundColor = whiteKeyDownColor
    }
    
    @IBAction func whiteKeyUp(_ sender: UIButton) {
        sender.backgroundColor = whiteKeyNormalColor
    }
    
    // MARK: - Play Some Notes
    func keyOn(_ keyNumber: Int) {
        
    }
    
    func keyOff(_ keyNumber: Int) {
        
    }
    
    func noteOn(_ noteNumber: Int) {
        
    }
    
    func noteOff(_ noteNumber: Int) {
        
    }
    
}

