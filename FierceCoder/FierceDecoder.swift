//
//  FierceDecoder.swift
//  FierceCoder
//
//  Created by David House on 7/24/15.
//  Copyright © 2015 David House. All rights reserved.
//

import Foundation

public class FierceDecoder {

    var decoder:NSKeyedUnarchiver
    
    public init(data:NSData) {
        self.decoder = NSKeyedUnarchiver(forReadingWithData: data)
    }
    
    public func decode(key:String = "fierceRootObject") -> FierceDecoder {
        if let rawObject = self.decoder.decodeObjectForKey(key) as? NSData {
            let innerDecoder = FierceDecoder(data: rawObject)
            return innerDecoder
        }
        else {
            let innerDecoder = FierceDecoder(data: NSData())
            return innerDecoder
        }
    }

    public func decodeObject(key:String = "fierceRootObject") -> AnyObject? {
        if let object = self.decoder.decodeObjectForKey(key) {
            return object
        }
        else {
            return nil
        }
    }
    
    public func decodeArray(key:String = "fierceRootObject") -> [FierceDecoder] {
        var decoders = Array<FierceDecoder>()
        if let encodedObjects = self.decoder.decodeObjectForKey(key) as? [NSData] {
            for encodedData in encodedObjects {
                decoders.append(FierceDecoder(data: encodedData))
            }
        }
        return decoders
    }
}