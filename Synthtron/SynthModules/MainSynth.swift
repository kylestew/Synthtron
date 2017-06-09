import AudioKit
import AVKit

class MainSynth {
    
    // singleton
    static let sharedInstance = MainSynth()
    
    //************************************************************
    // MARK: - Exposed Synth Params
    //************************************************************
    
    let attackMax = 2.0
    var attack:Double = 1.0 {
        didSet {
            print("Attack \(attack)")
//            dualVCO.attack = 
        }
    }
    
    let decayMax = 2.0
    var decay:Double = 1.0 {
        didSet {
        }
    }
    
    let sustainMax = 2.0
    var sustain:Double = 1.0 {
        didSet {
        }
    }
    
    let releaseMax = 2.0
    var release:Double = 1.0 {
        didSet {
        }
    }

    let reverbMax = 1.0
    var reverbAmount = 0.0 {
        didSet {
//            reverb.dryWetMix = reverbAmount
        }
    }
    
    let delayMax = 1.0
    var delayAmount = 0.0 {
        didSet {
//            delay.dryWetMix = Rescale(from: (0, 1), to: (0, 0.75)).rescale(delayAmount)
        }
    }
    
    //************************************************************
    // MARK: - Synth Nodes
    //************************************************************
    
    /*
    var filter: LPFwithLFO
    var reverb: AKReverb
    var delay: AKDelay
     */
    var dualVCO: DualVCO
    var output: AKMixer
    
    init() {
        dualVCO = DualVCO()
        
//        sequence8 = Sequence8(dualVCO)
//        sequence8.generateSequence()
//        sequence8.sequence.setTempo(tempo)
//        
//        filter = LPFwithLFO(sequence8)
//        
//        // allow the filter to be gated by note on/offs from the VCO
//        dualVCO.filterEnvelope = filter
//        
//        reverb = AKReverb(filter)
//        reverb.dryWetMix = reverbAmount
//        reverb.loadFactoryPreset(.plate)
//        
//        delay = AKDelay(reverb)
//        delay.time = 0.15
//        delay.feedback = 0.2
//        delay.dryWetMix = delayAmount
        
//        output = AKMixer(delay)
        output = AKMixer(dualVCO)
        
        AudioKit.output = output
        AudioKit.start()
        
//        do {
//            try AKSettings.setSession(category: .playAndRecord)
//        } catch {
//            AKLog("Could not setup for recording")
//        }
    }
    
    var currentMIDINote: MIDINoteNumber = 0
    
    // MARK: - Play Some Notes
    func noteOn(_ note: MIDINoteNumber) {
        currentMIDINote = note
        dualVCO.play(noteNumber: note, velocity: 120)
    }
    
    func noteOff(_ note: MIDINoteNumber) {
        if currentMIDINote == note {
            dualVCO.stop(noteNumber: note)
        }
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
