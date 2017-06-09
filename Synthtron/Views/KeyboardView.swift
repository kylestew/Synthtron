import UIKit

private enum PianoKeyType {
    case black
    case white
}

private struct PianoKey {
    let type: PianoKeyType
    let index: Int
    var isDown = false
    var rect = CGRect.zero
    
    init(type: PianoKeyType, index: Int) {
        self.type = type
        self.index = index
    }
}

protocol KeyboardViewNoteDelegate {
    func midiNoteDown(midiNoteNumber: Int)
    func midiNoteUp(midiNoteNumber: Int)
}

@IBDesignable
class KeyboardView: UIView {
    
    var delegate: KeyboardViewNoteDelegate?
    var baseMIDINoteNumber = 36 // C3
    
    @IBInspectable var whiteKeyColor: UIColor = UIColor.white
    @IBInspectable var whiteKeyDownColor: UIColor = UIColor.red
    @IBInspectable var blackKeyColor: UIColor = UIColor.black
    @IBInspectable var blackKeyDownColor: UIColor = UIColor.red
    
    @IBInspectable var keyCount: Int = 20
    @IBInspectable var keySpacing: CGFloat = 4.0
    @IBInspectable var blackKeyWidthPercentage: CGFloat = 0.8
    @IBInspectable var blackKeyHeightPercentage: CGFloat = 0.5
    @IBInspectable var blackKeyCornerRadius: CGFloat = 2.0
    
    private let whiteBlackSequence: [PianoKeyType] = [.white, .black, .white, .black, .white, .white, .black, .white, .black, .white, .black, .white]
    private let blackOffsetRuns = [ -1, 1, -1, 0, 1 ] // black keys have a pattern of offsets for visual appearance
    private var keys: [PianoKey] = []
    private var numWhiteKeys = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sequenceKeys()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sequenceKeys()
    }
    
    private func sequenceKeys() {
        keys = []
        for i in 0..<keyCount {
            keys.append(PianoKey(type: whiteBlackSequence[i % whiteBlackSequence.count], index: i))
        }
        numWhiteKeys = keys.filter{ $0.type == .white }.count
    }
    
    override func prepareForInterfaceBuilder() {
        sequenceKeys()
    }
    
    override func draw(_ rect: CGRect) {
        let keySpacingTotal = CGFloat(numWhiteKeys - 1) * keySpacing
        // due to accumulative rouning errors, don't snap key widths to whole pixels
        let wkWidth = (bounds.width - keySpacingTotal) / CGFloat(numWhiteKeys)
        let wkHeight = bounds.height
        let bkWidth = CGFloat(wkWidth * blackKeyWidthPercentage)
        let bkHeight = round(bounds.height * blackKeyHeightPercentage)
        
        let whiteRect = CGRect(x: 0, y: 0, width: wkWidth, height: wkHeight)
        let blackRect = CGRect(x: round(-(bkWidth + keySpacing) / 2.0), y: -blackKeyCornerRadius, width: bkWidth, height: bkHeight)
        let blackRectOffset: CGFloat = round(bkWidth * 0.08)
        
        // layout all key positions
        var curX: CGFloat = 0
        var blackKeyIdx = 0
        for i in keys.indices {
            var toMove: CGFloat
            switch keys[i].type {
            case .white:
                keys[i].rect = whiteRect
                toMove = wkWidth + keySpacing
            case .black:
                // determine visual offset for black key placement
                if blackKeyIdx >= blackOffsetRuns.count {
                    blackKeyIdx = 0
                }
                let offset = CGFloat(blackOffsetRuns[blackKeyIdx]) * blackRectOffset
                var rect = blackRect
                
                // place black key
                rect.origin.x += offset
                keys[i].rect = rect
                
                toMove = 0.0 // black keys are in-between
                blackKeyIdx += 1
            }
            keys[i].rect.origin.x += curX
            curX += toMove
        }
        
        func drawKeys(type: PianoKeyType) {
            for key in keys {
                switch type {
                case .white:
                    if type == key.type {
                        key.isDown ? whiteKeyDownColor.setFill() : whiteKeyColor.setFill()
                        UIRectFill(key.rect)
                    }
                case .black:
                    if type == key.type {
                        key.isDown ? blackKeyDownColor.setFill() : blackKeyColor.setFill()
                        let keyPath = UIBezierPath(roundedRect: key.rect, cornerRadius: blackKeyCornerRadius)
                        keyPath.fill()
                    }
                }
            }
        }
        
        // layout the white keys
        drawKeys(type: .white)
        
        // layout the black keys
        drawKeys(type: .black)
    }
    
    fileprivate func keyAtPoint(_ point: CGPoint) -> PianoKey? {
        let touched = keys.filter { $0.rect.contains(point) }
        if touched.count == 1 {
            return touched.first
        } else {
            // if more than one key at point, pick first black key
            return touched.filter { $0.type == .black }.first
        }
    }
    
    func enforceMonophonic() {
        // HACK: this will retrigger envelope... probably not what we want here
        for (index, key) in keys.enumerated() {
            if key.isDown == true {
                keyUp(forIndex: index)
            }
        }
    }
    
    func keyDown(forIndex index: Int) {
        if index < keys.count && keys[index].isDown == false {
            enforceMonophonic()
            
            keys[index].isDown = true
            
            print("Key down \(index)")
            
            if let noteDelgate = delegate {
                noteDelgate.midiNoteDown(midiNoteNumber: baseMIDINoteNumber + index)
            }
            
            self.setNeedsDisplay()
        }
    }
    
    func keyUp(forIndex index: Int) {
        if index < keys.count && keys[index].isDown == true {
            keys[index].isDown = false
            
            print("Key up \(index)")
            
            if let noteDelgate = delegate {
                noteDelgate.midiNoteUp(midiNoteNumber: baseMIDINoteNumber + index)
            }
            
            self.setNeedsDisplay()
        }
    }
    
    func keyDown(forMidiNoteNumber noteNumber: Int) {
        // TODO: allow MIDI input to control keys on this keyboard
    }
    
}

extension KeyboardView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // find key underneath touch
            if let key = keyAtPoint(touch.location(in: self)) {
                keyDown(forIndex: key.index)
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // find key underneath touch
            if let key = keyAtPoint(touch.location(in: self)) {
                keyDown(forIndex: key.index)
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // find key underneath touch
            if let key = keyAtPoint(touch.location(in: self)) {
                keyUp(forIndex: key.index)
            }
        }
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            // find key underneath touch
            if let key = keyAtPoint(touch.location(in: self)) {
                keyUp(forIndex: key.index)
            }
        }
        super.touchesCancelled(touches, with: event)
    }
}
