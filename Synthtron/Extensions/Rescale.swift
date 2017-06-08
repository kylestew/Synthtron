import Foundation

struct Rescale {
    typealias RescaleDomain = (lowerBound: Double, upperBound: Double)
    
    var fromDomain: RescaleDomain
    var toDomain: RescaleDomain
    
    init(from: RescaleDomain, to: RescaleDomain) {
        self.fromDomain = from
        self.toDomain = to
    }
    
    func interpolate(_ x: Double ) -> Double {
        return self.toDomain.lowerBound * (1 - x) + self.toDomain.upperBound * x;
    }
    
    func interpolateLog(_ x: Double) -> Double {
        let min = log(self.toDomain.lowerBound + 1)
        let max = log(self.toDomain.upperBound + 1)
        let scale = max - min
        
        return exp(min + scale * x) - 1
    }
    
    // domain: [0, 1]
    func uninterpolate(_ x: Double) -> Double {
        let b = (self.fromDomain.upperBound - self.fromDomain.lowerBound) != 0 ? self.fromDomain.upperBound - self.fromDomain.lowerBound : 1 / self.fromDomain.upperBound;
        return (x - self.fromDomain.lowerBound) / b
    }
    
    func uninterpolateLog(_ x: Double) -> Double {
        let min = log(self.fromDomain.lowerBound + 1)
        let max = log(self.fromDomain.upperBound + 1)
        let scale = max - min
        
        return (log(x + 1) - min) / scale
    }
    
    func rescale(_ x: Double )  -> Double {
        return interpolate( uninterpolate(x) )
    }
    
    func rescaleLinToLog(_ x: Double ) -> Double {
        return interpolateLog( uninterpolate(x) )
    }
    
    func rescaleLogToLin(_ x: Double ) -> Double {
        return interpolate( uninterpolateLog(x) )
    }
}
