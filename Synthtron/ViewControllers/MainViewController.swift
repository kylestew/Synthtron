import UIKit
import AudioKit

class MainViewController: UIViewController, KeyboardViewNoteDelegate {
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var envAttackSlider: SliderView!
    
    
    let oscillator = AKOscillator()
    
    var currentMIDINote: MIDINoteNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardView.delegate = self
        
//        AudioKit.output = oscillator
//        AudioKit.start()
//        
//        oscillator.amplitude = 0.0
//        oscillator.start()
        
        setDefaultValues()
    }
    
    //************************************************************
    // MARK: - Defaults Setup
    //************************************************************
    
    func setDefaultValues() {
        envAttackSlider.delegate = self
    }
    
    
    //************************************************************
    // MARK: - Keyboard Delegate
    //************************************************************

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

//************************************************************
// MARK: - Slider Delegate
//************************************************************

extension MainViewController : SliderDelegate {
    func sliderValueDidChange(_ value: Double, tag: Int) {
        print(value)
        print(value)
    }
//    func knobValueDidChange(_ value: Double, tag: Int) {
//        switch tag {
//        case 100:
//            synth.tempo = value
//            updateTempoLabel()
//        case 200:
//            synth.volume = value
//        case 300:
//            synth.delayAmount = value
//        case 400:
//            synth.reverbAmount = value
//        default:
//            break
//        }
//    }
}

