import AudioKit
import AVKit

class MainSynth {
    
    // singleton
    static let sharedInstance = MainSynth()
    
    //************************************************************
    // MARK: - Exposed Synth Params
    //************************************************************
    
    let attackMax = 0.5
    var attack:Double {
        get {
            return dualVCO.attackDuration
        }
        set {
            dualVCO.attackDuration = newValue
        }
    }
    
    let decayMax = 0.5
    var decay:Double {
        get {
            return dualVCO.decayDuration
        }
        set {
            dualVCO.decayDuration = newValue
        }
    }
    
    let sustainMax = 1.0
    var sustain:Double {
        get {
            return dualVCO.sustainLevel
        }
        set {
            dualVCO.sustainLevel = newValue
        }
    }
    
    let releaseMax = 1.0
    var release:Double {
        get {
            return dualVCO.releaseDuration
        }
        set {
            dualVCO.releaseDuration = newValue
        }
    }
    
    let reverbMax = 0.5
    var reverbAmount = 0.0 {
        didSet {
            reverb.dryWetMix = reverbAmount
        }
    }
    
    let delayMax = 1.0
    var delayAmount = 0.0 {
        didSet {
            delay.dryWetMix = Rescale(from: (0, 1), to: (0, 0.75)).rescale(delayAmount)
            delay.time = Rescale(from: (0, 1), to: (0.05, 0.3)).rescale(delayAmount)
        }
    }
    
    //************************************************************
    // MARK: - Synth Nodes
    //************************************************************
    
    private var dualVCO: DualVCO
    
    private var filter: LPFwithLFO
    
    private var reverb: AKReverb
    private var delay: AKDelay
    
    private var output: AKMixer
    
    init() {
        dualVCO = DualVCO()
        
        filter = LPFwithLFO(dualVCO)
        
//        // allow the filter to be gated by note on/offs from the VCO
//        dualVCO.filterEnvelope = filter
        
        reverb = AKReverb(filter)
        reverb.dryWetMix = reverbAmount
        reverb.loadFactoryPreset(.plate)
        
        delay = AKDelay(reverb)
        delay.time = 0.15
        delay.feedback = 0.2
        delay.dryWetMix = delayAmount
        
        output = AKMixer(delay)
        
        AudioKit.output = output
        AudioKit.start()
        
        // apply initial high level settings
        updateDirty()
        updateFat()
        updateThin()
        
//        do {
//            try AKSettings.setSession(category: .playAndRecord)
//        } catch {
//            AKLog("Could not setup for recording")
//        }
    }
    
    var currentMIDINote: MIDINoteNumber = 0
    
    // MARK: - Play Some Notes
    func noteOn(_ note: MIDINoteNumber, velocity: Int) {
        currentMIDINote = note
        dualVCO.play(noteNumber: note, velocity: MIDIVelocity(velocity))
        
        filter.gate = 1.0
    }
    
    func noteOff(_ note: MIDINoteNumber) {
        if currentMIDINote == note {
            dualVCO.stop(noteNumber: note)
            
            filter.gate = 0.0
        }
    }

    
    //************************************************************
    // MARK: Abstract Parameters
    //************************************************************
    
    // DIRTY
    // detune dual osciallators slightly
    // add a little LFO wobble on the LPF
    let dirtyMax = 1.0
    var dirty:Double = 0.5 {
        didSet { updateDirty() }
    }
    func updateDirty() {
        dualVCO.detune = Rescale(from: (0, 1), to: (0, 4)).rescale(dirty)
        filter.lfoAmplitude = Rescale(from: (0, 1), to: (0, 200)).rescale(dirty)
        filter.lfoRate = 0.2
    }
    
    // FAT
    // low pass filter cutoff
    let fatMax = 1.0
    var fat:Double = 0.5 {
        didSet { updateFat() }
    }
    func updateFat() {
        filter.cutoffFrequency = Rescale(from: (0, 1), to: (200, 2000)).rescale(1.0 - fat)
    }
    
    // THIN
    // low pass filter res
    let thinMax = 1.0
    var thin:Double = 0.5 {
        didSet { updateThin() }
    }
    func updateThin() {
        filter.resonance = thin
    }
    
    //************************************************************
    // MARK: Recording
    //************************************************************
    /*
    
    var recorder:AKNodeRecorder?
    
    func isRecording() -> Bool {
        if let rec = recorder {
            return rec.isRecording
        }
        return false
    }
    
    func startRecording(completion: @escaping (_ started: Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            
            if granted {
                AKAudioFile.cleanTempDirectory()
                do {
                    self.recorder = try AKNodeRecorder(node: self.output)
                    AKLog((self.recorder?.audioFile?.directoryPath.absoluteString)!)
                    AKLog((self.recorder?.audioFile?.fileNamePlusExtension)!)
                    try self.recorder?.record()
                    
                    completion(true)
                } catch {
                    completion(false)
                }
            } else {
                completion(false)
            }
            
        })
    }
    
    func stopRecording(completion: @escaping (_ success: Bool, _ file: URL?) -> Void) {
        if let rec = recorder {
            rec.stop()
            if let file = rec.audioFile {
                
                let fileName = "FlowSynthRecording.m4a"
                var fileUrl:URL?
                do {
                    let docsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    fileUrl = docsUrl.appendingPathComponent(fileName)
                    if FileManager.default.fileExists(atPath: fileUrl!.path) {
                        try FileManager.default.removeItem(at: fileUrl!)
                    }
                } catch {
                    print("error removing file")
                }
                
                file.exportAsynchronously(name: fileName,
                                          baseDir: .documents,
                                          exportFormat: .m4a) {_, exportError in
                                            
                                            if let error = exportError {
                                                print(error)
                                                completion(false, nil)
                                            } else {
                                                completion(true, fileUrl)
                                            }
                                            
                }
            }
        }
    }
 */
    
}
