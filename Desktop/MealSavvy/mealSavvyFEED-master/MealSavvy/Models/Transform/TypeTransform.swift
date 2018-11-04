//
//  TypeTransform.swift
//  Vibes
//

import ObjectMapper

class TypeTransform {
    static let bool = TransformOf<Bool, String>(fromJSON: { (value: String?) -> Bool? in
        if let value = value {
            return value == "1" ? true : false
        } else {
            return false
        }
    }, toJSON: { (value: Bool?) -> String? in
        return (value ?? false) ? "1" : "0"
    })
    
    static let int = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        if let value = value {
            return Int(value)
        }
        
        return nil
    }, toJSON: { (value: Int?) -> String? in
        if let value = value {
            return String(value)
        }
        
        return nil
    })
    
    static let uint = TransformOf<UInt, String>(fromJSON: { (value: String?) -> UInt? in
        if let value = value {
            return UInt(value)
        }
        
        return nil
    }, toJSON: { (value: UInt?) -> String? in
        if let value = value {
            return String(value)
        }
        
        return nil
    })
    
    static let float = TransformOf<Float, String>(fromJSON: { (value: String?) -> Float? in
        if let value = value {
            return Float(value)
        }
        
        return nil
    }, toJSON: { (value: Float?) -> String? in
        if let value = value {
            return String(value)
        }
        
        return nil
    })
    
    static let double = TransformOf<Double, String>(fromJSON: { (value: String?) -> Double? in
        if let value = value {
            return Double(value)
        }
        
        return nil
    }, toJSON: { (value: Double?) -> String? in
        if let value = value {
            return String(value)
        }
        
        return nil
    })
}
