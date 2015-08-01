# FierceCoder
A thin Swift wrapper around the NSCoding protocol.

NOTE: This is still very much a work in progress.

## Features

This wrapper provides a Swift protocol and two classes to encode and decode data. This allows for Swift Structs or Classes to use NSCoding without having to conform directly to that protocol and the Objective-C requirements that entails.

## Requirements

- iOS 7.0+ / Mac OS X 10.9+
- Xcode 7

## Installation

CocoaPods and Carthage support coming soon (Carthage may just work, I haven't tested it yet). Otherwise simply add the FierceCoder project to your workspace and set the FierceCoder as a framework reference.

---

## Usage

### Encoding primitive objects

Any object that is bridged to an Objective-C object that can be encoded by the NSKeyedArchiver can be directly encoded by the FierceCoder. The FierceEncoder provides an encodedData() function that returns an NSData instance containing the encoded data. The FierceDecoder takes in an encoded NSData value as a parameter to the init and allows access to the decoded objects.

```swift
import FierceCoder

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
```

### Encoding Swift Struct or Class

To encode a Swift Struct or Class, just implement the FierceEncodeable protocol. It has a method for encoding and an init that can be overridden to provide decoding. Once this protocol is implemented, the Struct or Class can be encoded by using the .encode and .decode methods on the FierceEncoder and FierceDecoder.

```swift
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
```

### Encoding an array of Structs or Classes

The FierceEncoder and FierceDecoder classes provide methods for encoding and decoding an array of objects that implement the FierceEncodeable protocol. Note that the decoder for an array returns an array of FierceDecoder objects that can be used to construct the decoded objects.

```swift

let myStructs = [StructTest(name: "fred", title: "rock crusher", age: 45),StructTest(name: "barney", title: "rock crusher", age: 40)]

let encoder = FierceEncoder()
encoder.encodeArray(myStructs,key:"array")
let encodedData = coder.encodedData()

let decoder = FierceDecoder(data: encodedData)
let encodedObjects = decoder.decodeArray("array")
var encodedStructs = Array<StructTest>()
for encodedObject in encodedObjects {
    encodedStructs.append(StructTest(decoder: encodedObject))
}
```


## License

FierceCoder is released under the MIT license. See LICENSE for details.
