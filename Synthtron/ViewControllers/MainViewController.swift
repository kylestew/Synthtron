import UIKit
import AudioKit

class MainViewController: UIViewController, KeyboardViewNoteDelegate {
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var envAttackSlider: SliderView!
    @IBOutlet weak var envDecaySlider: SliderView!
    @IBOutlet weak var envSustainSlider: SliderView!
    @IBOutlet weak var envReleaseSlider: SliderView!
    
    var currentMIDINote: MIDINoteNumber = 0
    
    let synth = MainSynth.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardView.delegate = self
        
        setDefaultValues()
    }
    
    //************************************************************
    // MARK: - Defaults Setup
    //************************************************************
    
    func setDefaultValues() {
        // envelope
        envAttackSlider.maxValue = synth.attackMax
        envAttackSlider.value = synth.attack
        envAttackSlider.delegate = self
        
        envDecaySlider.maxValue = synth.decayMax
        envDecaySlider.value = synth.decay
        envDecaySlider.delegate = self
        
        envSustainSlider.maxValue = synth.sustainMax
        envSustainSlider.value = synth.sustain
        envSustainSlider.delegate = self
        
        envReleaseSlider.maxValue = synth.releaseMax
        envReleaseSlider.value = synth.release
        envReleaseSlider.delegate = self
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
//        currentMIDINote = note
//        // start from the correct note if amplitude is zero
//        if oscillator.amplitude == 0 {
//            oscillator.rampTime = 0
//        }
//        oscillator.frequency = note.midiNoteToFrequency()
//
//        // Still use rampTime for volume
//        oscillator.amplitude = 0.2
//        oscillator.play()
    }
    
    func noteOff(_ note: MIDINoteNumber) {
//        if currentMIDINote == note {
//            oscillator.amplitude = 0
//        }
    }
    
}

//************************************************************
// MARK: - Slider Delegate
//************************************************************

extension MainViewController: SliderDelegate {
    func sliderValueDidChange(_ value: Double, tag: Int) {
        switch tag {
        case 100:
            synth.attack = value
        case 101:
            synth.decay = value
        case 102:
            synth.sustain = value
        case 103:
            synth.release = value
        default:
            break
        }
    }
}

//************************************************************
// MARK: - Knob Delegate
//************************************************************

// TODO:
