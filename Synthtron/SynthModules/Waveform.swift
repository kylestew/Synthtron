import UIKit

enum Waveform: Int {
    case Silent
    case Sine
    case Triangle
    case Square
    case SquareHighPWM
    case Sawtooth
    case ReverseSawtooth
    
    func bezierPath(withBounds bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        let lhsTop = CGPoint(x: 0, y: 0)
        let lhsCenter = CGPoint(x: 0, y: bounds.size.height / 2.0)
        let rhsCenter = CGPoint(x: bounds.size.width, y: bounds.size.height / 2.0)
        let rhsBottom = CGPoint(x: bounds.size.width, y: bounds.size.height)
        let topLeftOfMid = CGPoint(x: bounds.size.width / 4.0, y: 0)
        let topMid = CGPoint(x: bounds.size.width / 2.0, y: 0)
        let topRightOfMid = CGPoint(x: bounds.size.width * (3.0 / 4.0), y: 0)
        let bottomLeftOfMid = CGPoint(x: bounds.size.width / 4.0, y: bounds.size.height)
        let bottomMid = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height)
        let bottomRightOfMid = CGPoint(x: bounds.size.width * (3.0 / 4.0), y: bounds.size.height)
        let center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        
        switch self {
            
        case .Sine:
            path.move(to: lhsCenter)
            var cp1 = topLeftOfMid
            cp1.y -= center.y
            var cp2 = bottomRightOfMid
            cp2.y += center.y
            path.addQuadCurve(to: center, controlPoint: cp1)
            path.addQuadCurve(to: rhsCenter, controlPoint: cp2)
            
        case .Triangle:
            path.move(to: lhsCenter)
            path.addLine(to: topLeftOfMid)
            path.addLine(to: bottomRightOfMid)
            path.addLine(to: rhsCenter)
            
        case .Square:
            path.move(to: lhsCenter)
            path.addLine(to: lhsTop)
            path.addLine(to: topMid)
            path.addLine(to: bottomMid)
            path.addLine(to: rhsBottom)
            path.addLine(to: rhsCenter)
            
        case .SquareHighPWM:
            path.move(to: lhsCenter)
            path.addLine(to: lhsTop)
            path.addLine(to: topRightOfMid)
            path.addLine(to: bottomRightOfMid)
            path.addLine(to: rhsBottom)
            path.addLine(to: rhsCenter)
            
        case .Sawtooth:
            path.move(to: lhsCenter)
            path.addLine(to: topLeftOfMid)
            path.addLine(to: bottomLeftOfMid)
            path.addLine(to: topRightOfMid)
            path.addLine(to: bottomRightOfMid)
            path.addLine(to: rhsCenter)
            
        case .ReverseSawtooth:
            path.move(to: lhsCenter)
            path.addLine(to: bottomLeftOfMid)
            path.addLine(to: topLeftOfMid)
            path.addLine(to: bottomRightOfMid)
            path.addLine(to: topRightOfMid)
            path.addLine(to: rhsCenter)
            
        default:
            path.move(to: lhsCenter)
            path.addLine(to: rhsCenter)
        }
        
        return path
    }
}
