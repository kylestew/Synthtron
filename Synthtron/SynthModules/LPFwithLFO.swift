import AudioKit

class LPFwithLFO: AKNode {
    
    var parameters:[Double]
    
    var cutoffFrequency: Double = 2_000 {
        didSet {
            parameters[0] = cutoffFrequency
            output.parameters = parameters
        }
    }
    
    var resonance: Double = 0.4 {
        didSet {
            parameters[1] = resonance
            output.parameters = parameters
        }
    }
    
    var lfoAmplitude: Double = 0 {
        didSet {
            parameters[2] = lfoAmplitude
            output.parameters = parameters
        }
    }
    
    var lfoRate: Double = 4 {
        didSet {
            parameters[3] = lfoRate
            output.parameters = parameters
        }
    }
    
    var waveform: Waveform = .Sine {
        didSet {
            switch waveform {
            case .Sine:
                parameters[4] = 0
            case .Square:
                parameters[4] = 1
            case .Sawtooth:
                parameters[4] = 2
            case .ReverseSawtooth:
                parameters[4] = 3
            default:
                parameters[4] = 0
            }
            output.parameters = parameters
        }
    }
    
    var gate:Double = 0 {
        didSet {
            parameters[5] = gate
            output.parameters = parameters
        }
    }
    
    var cutoffEnvelopeAmount:Double = 2 {
        didSet {
            print("env cut: \(cutoffEnvelopeAmount)")
            
            parameters[6] = cutoffEnvelopeAmount
            output.parameters = parameters
        }
    }
    
    var output: AKOperationEffect
    
    init(_ input: AKNode) {
        
        // set parameter defaults
        parameters = [ cutoffFrequency, resonance, lfoAmplitude, lfoRate, 0, 0, cutoffEnvelopeAmount ]
        
        output = AKOperationEffect(input) { input, parameters in
            let cutoff = parameters[0]
            let rez = parameters[1]
            let oscAmp = parameters[2]
            let oscRate = parameters[3]
            let oscIndex = parameters[4]
            let gate = parameters[5]
            let cutoffEnvelopeAmount = parameters[6]
            
            let cutoffEnvelope = cutoff.gatedADSREnvelope(gate: gate,
                                                          attack: 0.05,
                                                          decay: 0.01,
                                                          sustain: 0.8,
                                                          release: 0.4)
            
            // 0 = sine, 1 = square, 2 = sawtooth, 3 = reversed sawtooth
            let lfo = AKOperation.morphingOscillator(frequency: oscRate,
                                                     amplitude: oscAmp / 2,
                                                     index: oscIndex)
            
            return input.moogLadderFilter(cutoffFrequency: max(lfo + (oscAmp / 2) + cutoff + (cutoffEnvelopeAmount * cutoffEnvelope), 0),
                                          resonance: rez)
        }
        output.parameters = parameters
        
        super.init()
        self.avAudioNode = output.avAudioNode
    }
    
}
