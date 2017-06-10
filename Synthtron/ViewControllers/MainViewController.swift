import UIKit
import AudioKit
import RxSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var envAttackSlider: SliderView!
    @IBOutlet weak var envDecaySlider: SliderView!
    @IBOutlet weak var envSustainSlider: SliderView!
    @IBOutlet weak var envReleaseSlider: SliderView!
    
    @IBOutlet weak var dirtySlider: SliderView!
    @IBOutlet weak var fatSlider: SliderView!
    @IBOutlet weak var thinSlider: SliderView!
    
    @IBOutlet weak var reverbKnob: KnobView!
    @IBOutlet weak var delayKnob: KnobView!
    
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
        
        
        dirtySlider.sliderValue.value = Rescale(from: (0, synth.dirtyMax), to: (0, 1)).rescale(synth.dirty)
        dirtySlider.sliderValue.asObservable().map { value in
            return Rescale(from: (0, 1), to: (0, MainSynth.sharedInstance.dirtyMax)).rescale(value)
            }.subscribe(onNext: {
                MainSynth.sharedInstance.dirty = $0
            }).addDisposableTo(disposeBag)
        
        fatSlider.sliderValue.value = Rescale(from: (0, synth.fatMax), to: (0, 1)).rescale(synth.fat)
        fatSlider.sliderValue.asObservable().map { value in
            return Rescale(from: (0, 1), to: (0, MainSynth.sharedInstance.fatMax)).rescale(value)
            }.subscribe(onNext: {
                MainSynth.sharedInstance.fat = $0
            }).addDisposableTo(disposeBag)
        
        thinSlider.sliderValue.value = Rescale(from: (0, synth.thinMax), to: (0, 1)).rescale(synth.thin)
        thinSlider.sliderValue.asObservable().map { value in
            return Rescale(from: (0, 1), to: (0, MainSynth.sharedInstance.thinMax)).rescale(value)
            }.subscribe(onNext: {
                MainSynth.sharedInstance.thin = $0
            }).addDisposableTo(disposeBag)
        
        
        reverbKnob.knobValue.value = Rescale(from: (0, synth.reverbMax), to: (0, 1)).rescale(synth.reverbAmount)
        reverbKnob.knobValue.asObservable().map { value in
            return Rescale(from: (0, 1), to: (0, MainSynth.sharedInstance.releaseMax)).rescale(value)
            }.subscribe(onNext: {
                MainSynth.sharedInstance.reverbAmount = $0
            }).addDisposableTo(disposeBag)
        
        delayKnob.knobValue.value = Rescale(from: (0, synth.delayMax), to: (0, 1)).rescale(synth.delayAmount)
        delayKnob.knobValue.asObservable().map { value in
            return Rescale(from: (0, 1), to: (0, MainSynth.sharedInstance.delayMax)).rescale(value)
            }.subscribe(onNext: {
                MainSynth.sharedInstance.delayAmount = $0
            }).addDisposableTo(disposeBag)
    }
    
}

//************************************************************
// MARK: - Keyboard Delegate
//************************************************************

extension MainViewController: KeyboardViewNoteDelegate {
    
    func midiNoteDown(midiNoteNumber: Int, velocity: Int) {
        synth.noteOn(MIDINoteNumber(midiNoteNumber), velocity: velocity)
    }
    
    func midiNoteUp(midiNoteNumber: Int) {
        synth.noteOff(MIDINoteNumber(midiNoteNumber))
    }
    
}

