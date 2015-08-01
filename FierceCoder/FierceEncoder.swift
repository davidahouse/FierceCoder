//
//  FierceCoder.swift
//  FierceCoder
//
//  Created by David House on 7/24/15.
//  Copyright © 2015 David House. All rights reserved.
//

import Foundation

public class FierceEncoder {
    
    var encoded: NSMutableData?
    var encoder: NSKeyedArchiver
    
    public init() {
        self.encoded = NSMutableData()
        self.encoder = NSKeyedArchiver(forWritingWithMutableData:self.encoded!)
    }
    
    public func encodedData() -> NSData {
        self.encoder.finishEncoding()
        return self.encoded!
    }
    
    public func encode(object:FierceEncodeable,key:String = "fierceRootObject") {
        let objectEncoder = FierceEncoder()
        object.encode(objectEncoder)
        self.encoder.encodeObject(objectEncoder.encodedData(), forKey: key)
    }

    public func encodeObject(object:AnyObject,key:String = "fierceRootObject") {
        self.encoder.encodeObject(object, forKey: key)
    }
    
    public func encodeArray(objects:[FierceEncodeable],key:String = "fierceRootObject") {
        var encodedObjects = Array<NSData>()
        for object in objects {
            let objectEncoder = FierceEncoder()
            object.encode(objectEncoder)
            encodedObjects.append(objectEncoder.encodedData())
        }
        self.encoder.encodeObject(encodedObjects, forKey: key)
    }
}