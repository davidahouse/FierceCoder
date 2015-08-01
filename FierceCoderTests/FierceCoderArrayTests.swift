//
//  FierceCoderArrayTests.swift
//  FierceCoder
//
//  Created by David House on 7/27/15.
//  Copyright © 2015 David House. All rights reserved.
//

import XCTest
@testable import FierceCoder

struct StructWithArrayTest : FierceEncodeable {
    let name:String
    let values:[String]
    
    private enum EncoderKeys : String {
        case Name
        case Values
    }
    
    init(name:String,values:[String]) {
        self.name = name
        self.values = values
    }
    
    init(decoder:FierceDecoder) {
        self.name = decoder.decodeObject(EncoderKeys.Name.rawValue) as! String
        self.values = decoder.decodeObject(EncoderKeys.Values.rawValue) as! [String]
    }
    
    func encode(encoder: FierceEncoder) {
        encoder.encodeObject(self.name, key: EncoderKeys.Name.rawValue)
        encoder.encodeObject(self.values, key: EncoderKeys.Values.rawValue)
    }
}

class FierceCoderArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEncodeStringArray() {
        
        let strings = ["First","Second","Third","Fourth"]
        let encoder = FierceEncoder()
        encoder.encodeObject(strings)
    
        let rawData = encoder.encodedData()
        XCTAssertNotNil(rawData)
        XCTAssertTrue(rawData.length > 0)
        
        let decoder = FierceDecoder(data:rawData)
        if let decodedStrings = decoder.decodeObject() as? [String] {
            XCTAssertTrue(strings == decodedStrings)
        }
        else {
            XCTFail()
        }
    }
    
    func testEncodeStructWithArray() {
        
        let testStruct = StructWithArrayTest(name: "Fred", values: ["Barney","Wilma","Betty"])
        let encoder = FierceEncoder()
        testStruct.encode(encoder)
        
        let rawData = encoder.encodedData()
        XCTAssertNotNil(rawData)
        XCTAssertTrue(rawData.length > 0)
        
        let decoder = FierceDecoder(data:rawData)
        let decodedStruct = StructWithArrayTest(decoder: decoder)
        XCTAssertTrue(decodedStruct.name == testStruct.name)
        XCTAssertTrue(decodedStruct.values == testStruct.values)
    }
    
}
