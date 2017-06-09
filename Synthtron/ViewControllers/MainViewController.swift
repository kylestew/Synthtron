import UIKit
import AudioKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var envAttackSlider: SliderView!
    @IBOutlet weak var envDecaySlider: SliderView!
    @IBOutlet weak var envSustainSlider: SliderView!
    @IBOutlet weak var envReleaseSlider: SliderView!
    
    let disposeBag = DisposeBag()
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
        // each get initial value set from synth and binds next values back to the synth
        
        envAttackSlider.sliderValue.value = Rescale(from: (0, synth.attackMax), to: (0, 1)).rescale(synth.attack)
        envAttackSlider.sliderValue.asObservable().map { value in
            return Rescale(from: (0, 1), to: (0, MainSynth.sharedInstance.attackMax)).rescale(value)
            }.subscribe(onNext: {
                MainSynth.sharedInstance.attack = $0
            }).addDisposableTo(disposeBag)
        
        envDecaySlider.sliderValue.value = Rescale(from: (0, synth.decayMax), to: (0, 1)).rescale(synth.decay)
        envDecaySlider.sliderValue.asObservable().map { value in
            return Rescale(from: (0, 1), to: (0, MainSynth.sharedInstance.decayMax)).rescale(value)
            }.subscribe(onNext: {
                MainSynth.sharedInstance.decay = $0
            }).addDisposableTo(disposeBag)
        
        envSustainSlider.sliderValue.value = Rescale(from: (0, synth.sustainMax), to: (0, 1)).rescale(synth.sustain)
        envSustainSlider.sliderValue.asObservable().map { value in
            return Rescale(from: (0, 1), to: (0, MainSynth.sharedInstance.sustainMax)).rescale(value)
            }.subscribe(onNext: {
                MainSynth.sharedInstance.sustain = $0
            }).addDisposableTo(disposeBag)
        
        envReleaseSlider.sliderValue.value = Rescale(from: (0, synth.releaseMax), to: (0, 1)).rescale(synth.release)
        envReleaseSlider.sliderValue.asObservable().map { value in
            return Rescale(from: (0, 1), to: (0, MainSynth.sharedInstance.releaseMax)).rescale(value)
            }.subscribe(onNext: {
                MainSynth.sharedInstance.release = $0
            }).addDisposableTo(disposeBag)
    }
    
}

//************************************************************
// MARK: - Keyboard Delegate
//************************************************************

extension MainViewController: KeyboardViewNoteDelegate {
    
    func midiNoteDown(midiNoteNumber: Int) {
        synth.noteOn(MIDINoteNumber(midiNoteNumber))
    }
    
    func midiNoteUp(midiNoteNumber: Int) {
        synth.noteOff(MIDINoteNumber(midiNoteNumber))
    }
    
}

//************************************************************
// MARK: - Knob Delegate
//************************************************************

// TODO:
