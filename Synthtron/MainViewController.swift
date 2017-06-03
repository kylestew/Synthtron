import UIKit
import AudioKit

class MainViewController: UIViewController, KeyboardViewNoteDelegate {
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    let oscillator = AKOscillator()
    
    var currentMIDINote: MIDINoteNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardView.delegate = self
        
        AudioKit.output = oscillator
        AudioKit.start()
        
        oscillator.amplitude = 0.0
        oscillator.start()
    }

    // MARK: - Piano Key Delegate
    func midiNoteDown(midiNoteNumber: Int) {
        noteOn(MIDINoteNumber(midiNoteNumber))
    }
    
    func midiNoteUp(midiNoteNumber: Int) {
        noteOff(MIDINoteNumber(midiNoteNumber))
    }
    
    // MARK: - Play Some Notes
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

