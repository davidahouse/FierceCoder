//
//  FierceCoderTests.swift
//  FierceCoderTests
//
//  Created by David House on 7/24/15.
//  Copyright © 2015 David House. All rights reserved.
//

import XCTest
@testable import FierceCoder

struct StructTest : FierceEncodeable {
    let name:String
    let title:String
    let age:Int
    
    private enum EncoderKeys : String {
        case Name
        case Title
        case Age
    }
    
    init(name:String,title:String,age:Int) {
        self.name = name
        self.title = title
        self.age = age
    }
    
    init(decoder:FierceDecoder) {
        self.name = decoder.decodeObject(EncoderKeys.Name.rawValue) as! String
        self.title = decoder.decodeObject(EncoderKeys.Title.rawValue) as! String
        if let age = decoder.decodeObject(EncoderKeys.Age.rawValue) as? Int {
            self.age = age
        }
        else {
            self.age = 0
        }
    }
    
    func encode(encoder: FierceEncoder) {
        encoder.encodeObject(self.name, key: EncoderKeys.Name.rawValue)
        encoder.encodeObject(self.title, key: EncoderKeys.Title.rawValue)
        encoder.encodeObject(self.age, key: EncoderKeys.Age.rawValue)
    }
}

final class ClassTest : FierceEncodeable {
    let name:String
    let title:String
    
    private enum EncoderKeys : String {
        case Name
        case Title
    }
    
    init(name:String,title:String) {
        self.name = name
        self.title = title
    }

    init(decoder:FierceDecoder) {
        self.name = decoder.decodeObject(EncoderKeys.Name.rawValue) as! String
        self.title = decoder.decodeObject(EncoderKeys.Title.rawValue) as! String
    }
    
    func encode(encoder: FierceEncoder) {
        encoder.encodeObject(self.name, key: EncoderKeys.Name.rawValue)
        encoder.encodeObject(self.title, key: EncoderKeys.Title.rawValue)
    }
}

class FierceCoderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEncodingObjects() {
        
        let string = "A string"
        let number = 42
        let goodTime = [8,6,7,5,3,0,9]
        
        let coder = FierceEncoder()
        coder.encodeObject(string,key:"a_string")
        coder.encodeObject(number,key:"a_number")
        coder.encodeObject(goodTime,key:"an_array")
        let encodedData = coder.encodedData()
        
        let decoder = FierceDecoder(data: encodedData)
        let decodedString = decoder.decodeObject("a_string") as! String
        let decodedNumber = decoder.decodeObject("a_number") as! Int
        let decodedArray = decoder.decodeObject("an_array") as! [Int]
        XCTAssertTrue(string == decodedString)
        XCTAssertTrue(number == decodedNumber)
        XCTAssertTrue(goodTime.count == decodedArray.count)
        
        let myStructs = [StructTest(name: "fred", title: "rock crusher", age: 45),StructTest(name: "barney", title: "rock crusher", age: 40)]

    }
    
    func testEncodingString() {
        
        let encoder = FierceEncoder()
        let original = "This is the input string"
        encoder.encodeObject(original)

        let rawData = encoder.encodedData()
        XCTAssertNotNil(rawData)
        XCTAssertTrue(rawData.length > 0)
        
        let decoder = FierceDecoder(data:rawData)
        if let after = decoder.decodeObject() as? String {
            XCTAssertTrue(original == after)
        }
        else {
            XCTFail()
        }
    }
    
    func testDifferentKeys() {
        
        let encoder = FierceEncoder()
        let original = "This is the input string"
        encoder.encodeObject(original,key:"original")
        
        let rawData = encoder.encodedData()
        XCTAssertNotNil(rawData)
        XCTAssertTrue(rawData.length > 0)
        
        let decoder = FierceDecoder(data:rawData)
        if let after = decoder.decodeObject("after") as? String {
            XCTAssertFalse(original == after)
        }
    }
    
    func testBasicStructEncoding() {
        
        let aStruct = StructTest(name: "Fred", title: "Rock Crusher", age: 45)
        let encoder = FierceEncoder()
        aStruct.encode(encoder)
        
        let rawData = encoder.encodedData()
        XCTAssertNotNil(rawData)
        XCTAssertTrue(rawData.length > 0)
        
        let decoder = FierceDecoder(data:rawData)
        let bStruct = StructTest(decoder: decoder)
        XCTAssertTrue(aStruct.name == bStruct.name)
        XCTAssertTrue(aStruct.title == bStruct.title)
        XCTAssertTrue(aStruct.age == bStruct.age)
    }
    
    func testBasicClassEncoding() {
        
        let aStruct = ClassTest(name: "Fred", title: "Rock Crusher")
        let encoder = FierceEncoder()
        aStruct.encode(encoder)
        
        let rawData = encoder.encodedData()
        XCTAssertNotNil(rawData)
        XCTAssertTrue(rawData.length > 0)
        
        let decoder = FierceDecoder(data:rawData)
        let bStruct = ClassTest(decoder: decoder)
        XCTAssertTrue(aStruct.name == bStruct.name)
        XCTAssertTrue(aStruct.title == bStruct.title)
    }
}
