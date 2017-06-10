import AudioKit

class DualVCO: AKPolyphonicNode {
    
    var vco1WaveformIndex = 2.0 {
        didSet {
            vco1.index = min(max(vco1WaveformIndex, 0), 4)
        }
    }
    var vco1Waveform:Waveform = .Square {
        didSet {
            vco1WaveformIndex = indexFromWaveform(waveform: vco1Waveform)
        }
    }
    
    var vco2WaveformIndex = 1.0 {
        didSet {
            vco2.index = min(max(vco2WaveformIndex, 0), 4)
        }
    }
    var vco2Waveform:Waveform = .Triangle {
        didSet {
            vco2WaveformIndex = indexFromWaveform(waveform: vco2Waveform)
        }
    }
    
    // internal waveform index
    func indexFromWaveform(waveform: Waveform) -> Double {
        switch waveform {
        case .Silent:
            return 0
        case .Triangle:
            return 1
        case .Square:
            return 2
        case .SquareHighPWM:
            return 3
        case .Sawtooth:
            return 4
        default:
            return 0
        }
    }
    
    var detune = 0.0 {
        didSet {
            vco2.detuningOffset = detune
        }
    }
    
    var vcoMix = 0.5 {
        didSet {
            vcoMixer.balance = vcoMix
        }
    }
    
    var attackDuration = 0.1 {
        didSet {
            print(attackDuration)
            if attackDuration < 0.02 { attackDuration = 0.02 }
            vco1.attackDuration = attackDuration
            vco2.attackDuration = attackDuration
        }
    }
    
    var decayDuration = 0.1 {
        didSet {
            if decayDuration < 0.02 { decayDuration = 0.02 }
            vco1.decayDuration = decayDuration
            vco2.decayDuration = decayDuration
        }
    }
    
    var sustainLevel = 0.8 {
        didSet {
            vco1.sustainLevel = sustainLevel
            vco2.sustainLevel = sustainLevel
        }
    }
    
    var releaseDuration = 0.1 {
        didSet {
            if releaseDuration < 0.02 { releaseDuration = 0.02 }
            vco1.releaseDuration = releaseDuration
            vco2.releaseDuration = releaseDuration
        }
    }
    
    var vco1: AKMorphingOscillatorBank
    var vco2: AKMorphingOscillatorBank
    var vcoMixer: AKDryWetMixer
    
    override init() {
        var empty = AKTable()
        for i in empty.indices {
            empty[i] = 0.0
        }
        let triangle = AKTable(.triangle)
        let square = AKTable(.square)
        let sawtooth = AKTable(.sawtooth)
        var squareWithHighPWM = AKTable()
        let count = squareWithHighPWM.count
        for i in squareWithHighPWM.indices {
            if i < count / 8 {
                squareWithHighPWM[i] = -1.0
            } else {
                squareWithHighPWM[i] = 1.0
            }
        }
        
        vco1 = AKMorphingOscillatorBank(waveformArray: [empty, triangle, square, squareWithHighPWM, sawtooth])
        vco1.index = vco1WaveformIndex
        vco1.attackDuration = attackDuration
        vco1.decayDuration = attackDuration
        vco1.sustainLevel = sustainLevel
        vco1.releaseDuration = releaseDuration
        
        vco2 = AKMorphingOscillatorBank(waveformArray: [empty, triangle, square, squareWithHighPWM, sawtooth])
        vco2.index = vco2WaveformIndex
        vco2.attackDuration = attackDuration
        vco2.decayDuration = attackDuration
        vco2.sustainLevel = sustainLevel
        vco2.releaseDuration = releaseDuration
        
        vcoMixer = AKDryWetMixer(vco1, vco2, balance: vcoMix)
        
        super.init()
        
        avAudioNode = vcoMixer.avAudioNode
    }
    
    override func play(noteNumber: MIDINoteNumber, velocity: MIDIVelocity) {
        vco1.play(noteNumber: noteNumber, velocity: velocity)
        vco2.play(noteNumber: noteNumber, velocity: velocity)
    }
    
    override func stop(noteNumber: MIDINoteNumber) {
        vco1.stop(noteNumber: noteNumber)
        vco2.stop(noteNumber: noteNumber)
    }
    
}
