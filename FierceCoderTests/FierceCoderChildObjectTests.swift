//
//  FierceCoderChildObjectTests.swift
//  FierceCoder
//
//  Created by David House on 7/27/15.
//  Copyright © 2015 David House. All rights reserved.
//

import XCTest

struct ChildStructTest : FierceEncodeable {

    
    let name:String
    let age:Int
    
    private enum EncoderKeys : String {
        case Name
        case Age
    }

    init(name:String,age:Int) {
        self.name = name
        self.age = age
    }
    
    init(decoder:FierceDecoder) {
        if let name = decoder.decodeObject(EncoderKeys.Name.rawValue) as? String {
            self.name = name
        }
        else {
            self.name = ""
        }
        
        if let age = decoder.decodeObject(EncoderKeys.Age.rawValue) as? Int {
            self.age = age
        }
        else {
            self.age = 0
        }
    }
    
    func encode(encoder: FierceEncoder) {
        encoder.encodeObject(self.name, key: EncoderKeys.Name.rawValue)
        encoder.encodeObject(self.age, key: EncoderKeys.Age.rawValue)
    }
}

struct ParentStructTest : FierceEncodeable {
    let name:String
    let child:ChildStructTest
    
    private enum EncoderKeys : String {
        case Name
        case Child
    }
    
    init(name:String,childName:String,childAge:Int) {
        self.name = name
        self.child = ChildStructTest(name: childName, age: childAge)
    }
    
    init(decoder:FierceDecoder) {
        self.name = decoder.decodeObject(EncoderKeys.Name.rawValue) as! String
        self.child = ChildStructTest(decoder: decoder.decode(EncoderKeys.Child.rawValue))
    }
    
    func encode(encoder: FierceEncoder) {
        encoder.encodeObject(self.name, key: EncoderKeys.Name.rawValue)
        encoder.encode(self.child, key: EncoderKeys.Child.rawValue)
    }
}

struct ParentWithChildArray : FierceEncodeable {
    
    var children = [ChildStructTest]()
    
    init(children:[ChildStructTest]) {
        self.children = children
    }
    
    init(decoder: FierceDecoder) {
        self.children = [ChildStructTest]()
        let encodedChildren = decoder.decodeArray("children")
        for encodedChild in encodedChildren {
            self.children.append(ChildStructTest(decoder: encodedChild))
        }
    }
    
    func encode(encoder: FierceEncoder) {
        encoder.encodeArray(self.children.map{ $0 as FierceEncodeable }, key: "children")
    }
}

class FierceCoderChildObjectTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWithChild() {
        
        let parent = ParentStructTest(name: "Fred", childName: "Pebbles", childAge: 10)
        let encoder = FierceEncoder()
        parent.encode(encoder)
        
        let rawData = encoder.encodedData()
        XCTAssertNotNil(rawData)
        XCTAssertTrue(rawData.length > 0)
        
        let decoder = FierceDecoder(data:rawData)
        let decodedParent = ParentStructTest(decoder: decoder)
        XCTAssertTrue(parent.name == decodedParent.name)
    }
    
    func testParentWithChildArray() {
        
        let children = [ChildStructTest(name: "fred", age: 12),ChildStructTest(name: "barney", age: 21)]
        let parent = ParentWithChildArray(children: children)
        let encoder = FierceEncoder()
        parent.encode(encoder)
        
        let rawData = encoder.encodedData()
        XCTAssertNotNil(rawData)
        XCTAssertTrue(rawData.length > 0)

        let decoder = FierceDecoder(data: rawData)
        let decodedParent = ParentWithChildArray(decoder: decoder)
        XCTAssertTrue(children.count == decodedParent.children.count)
    }
}
