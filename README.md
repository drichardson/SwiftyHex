# SwiftyHex
SwiftyHex provides a hexidecimal encoder and decoder.

## Usage

### Encoding Bytes to String
    
    import SwiftyHex
    ...
    let bytes : [UInt8] = [1,2,3,4,5,6]
    let encodedString = SwiftyHex.Encode(bytes)

### Decoding String to Bytes
    
    import SwiftyHex
    ...
    let encodedString = "123abc"
    let (decodedBytes, ok) = SwiftyHex.Decode(encodedString)
    if ok {
        println("Got \(decodedBytes.count) bytes")
    } else {
        println("Failed to decode string.")
    }
 
    

## CocoaPods Installation

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SwiftyHex into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!
pod 'SwiftyHex', '~> 1.1'
```

Then, run the following command:

```bash
$ pod install
```
