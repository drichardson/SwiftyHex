//
//  SwiftyHexTests.swift
//  SwiftyHexTests
//
//  Created by Doug Richardson on 8/25/15.
//  Copyright (c) 2015 Doug Richardson. All rights reserved.
//

import XCTest
import SwiftyHex

class SwiftyHexTests: XCTestCase {
    
    func testDefaultEncoderIsLowercase() {
        let bytes : [UInt8] = [0x0a]
        XCTAssertEqual("0a", SwiftyHex.Encode(bytes))
    }
    
    func testCodecLowercase() {
        var bytes = [UInt8]()
        for i in 0..<256 {
            bytes.append(UInt8(i))
        }
        let encodedString = SwiftyHex.Encode(bytes, letterCase : .Lower)
        let (output, ok) = SwiftyHex.Decode(encodedString)
        XCTAssertTrue(ok)
        XCTAssertEqual(bytes, output)
    }
    
    func testCodecUppercase() {
        var bytes = [UInt8]()
        for i in 0..<256 {
            bytes.append(UInt8(i))
        }
        let encodedString = SwiftyHex.Encode(bytes, letterCase : .Upper)
        let (output, ok) = SwiftyHex.Decode(encodedString)
        XCTAssertTrue(ok)
        XCTAssertEqual(bytes, output)
    }
    
    func testDecodeEmpty() {
        let (output, ok) = SwiftyHex.Decode("")
        XCTAssertTrue(ok)
        XCTAssertEqual(output.count, 0)
    }
    
    func testDecodeOddLength() {
        let (output, ok) = SwiftyHex.Decode("0")
        XCTAssertFalse(ok)
        XCTAssertEqual(output.count, 0)
    }
    
    func testDecodeTwoUppercase() {
        let (output, ok) = SwiftyHex.Decode("AB")
        XCTAssertTrue(ok)
        XCTAssertEqual(output.count, 1)
        XCTAssertEqual(output[0], 0xAB)
    }
    
    func testDecodeTwoLowercase() {
        let (output, ok) = SwiftyHex.Decode("ab")
        XCTAssertTrue(ok)
        XCTAssertEqual(output.count, 1)
        XCTAssertEqual(output[0], 0xAB)
    }
    
    func testDecodeTwoDecimal() {
        let (output, ok) = SwiftyHex.Decode("78")
        XCTAssertTrue(ok)
        XCTAssertEqual(output.count, 1)
        XCTAssertEqual(output[0], 0x78)
    }
    
    func testDecodeInvalidCharacter() {
        let (output, ok) = SwiftyHex.Decode("0g")
        XCTAssertFalse(ok)
        XCTAssertEqual(output.count, 0)
    }
    
    func testEncodingPerformance() {
        var bytes = [UInt8]()
        for i in 0..<(10*1024) {
            bytes.append(UInt8(i%256))
        }
        
        self.measureBlock() {
            SwiftyHex.Encode(bytes, letterCase: .Lower)
        }
    }
    
    func testDecodingPerformance() {
        var bytes = [UInt8]()
        for i in 0..<(10*1024) {
            bytes.append(UInt8(i%256))
        }
        let encodedString = SwiftyHex.Encode(bytes)
        
        self.measureBlock() {
            SwiftyHex.Decode(encodedString)
        }
    }
}
