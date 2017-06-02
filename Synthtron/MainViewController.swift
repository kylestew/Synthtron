import UIKit
import AudioKit

class MainViewController: UIViewController {
    
    let whiteKeyNormalColor = UIColor(rgb: 0xFFFFFF)
    let whiteKeyDownColor = UIColor(rgb: 0xDDDDDD)
    let blackKeyNormalColor = UIColor(rgb: 0x232425)
    let blackKeyDownColor = UIColor(rgb: 0x434445)
    
    let oscillator = AKOscillator()
    
    let baseNoteMIDI: MIDINoteNumber = 36 // C3
    var currentMIDINote: MIDINoteNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AudioKit.output = oscillator
        AudioKit.start()
        
        oscillator.amplitude = 0.0
        oscillator.start()
    }

    //MARK: - Piano Key Actions
    
    @IBAction func whiteKeyDown(_ sender: UIButton) {
        sender.backgroundColor = whiteKeyDownColor
        keyOn(sender.tag)
    }
    
    @IBAction func whiteKeyUp(_ sender: UIButton) {
        sender.backgroundColor = whiteKeyNormalColor
        keyOff(sender.tag)
    }
    
    @IBAction func blackKeyDown(_ sender: UIButton) {
        sender.backgroundColor = blackKeyDownColor
        keyOn(sender.tag)
    }
    
    @IBAction func blackKeyUp(_ sender: UIButton) {
        sender.backgroundColor = blackKeyNormalColor
        keyOff(sender.tag)
    }
    
    // MARK: - Play Some Notes
    
    // map key tags to note numbers
    
    func keyOn(_ keyNumber: Int) {
        print(keyNumber)
        noteOn(baseNoteMIDI + MIDINoteNumber(keyNumber))
    }
    
    func keyOff(_ keyNumber: Int) {
        noteOff(baseNoteMIDI + MIDINoteNumber(keyNumber))
    }
    
    func noteOn(_ note: MIDINoteNumber) {
        
        currentMIDINote = note
        // start from the correct note if amplitude is zero
        if oscillator.amplitude == 0 {
            oscillator.rampTime = 0
        }
        oscillator.frequency = note.midiNoteToFrequency()

        // Still use rampTime for volume
        oscillator.amplitude = 0.2
        oscillator.play()
    }
    
    func noteOff(_ note: MIDINoteNumber) {
        if currentMIDINote == note {
            oscillator.amplitude = 0
        }
    }
    
}

