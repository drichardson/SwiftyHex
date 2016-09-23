//
//  Codec.swift
//  SwiftyHex
//
//  Created by Doug Richardson on 8/25/15.
//  Copyright (c) 2015 Doug Richardson. All rights reserved.
//

import Foundation

/**
Encode a UInt8 sequence as a hexidecimal String.

- parameter bytes: Byte sequence to encode.
- parameter letterCase: Output uppercase or lowercase hex
- returns: The hex encoded string.
*/
public func Encode<S : Sequence>(_ bytes : S, letterCase : LetterCase = .Lower) -> String where S.Iterator.Element == UInt8 {
    var result = String()
    EncodeByteSequence(bytes, outputStream: &result, letterCase: letterCase)
    return result
}

/**
Decode a hexidecimal String to a [UInt8]. The input string must contain
an even number valid characters (0-9, a-f, and A-F).

- parameter str: String to decode. Should be characters 0-9, a-f, and A-F.
- returns: (byte array, true) on success, ([], false) on failure due to invalid character or odd number of input characters.
*/
public func Decode(_ str : String) -> ([UInt8], Bool) {
    return DecodeUTF8Sequence(str.utf8)
}

/**
Case to use to encode hexidecimal strings.

- Upper: Encode string using upper case hex characters.
- Lower: Encode string using lower case hex characters.
*/
public enum LetterCase {
    case Upper
    case Lower
}

/**
Encode a UInt8 sequence to an output stream.

- parameter bytes: Byte sequence to encode.
- parameter outputStream: Destination for the encoded string.
- parameter letterCase: Output uppercase or lowercase hex
*/

public func EncodeByteSequence<ByteSequence : Sequence, TargetStream : TextOutputStream>
    (_ bytes : ByteSequence, outputStream : inout TargetStream, letterCase : LetterCase) where ByteSequence.Iterator.Element == UInt8 {
    let table : [String]
    switch letterCase {
    case .Lower:
        table = lowercaseTable
    case .Upper:
        table = uppercaseTable
    }
    
    for b in bytes {
        let nibble1 = (b & 0b11110000) >> 4
        let nibble2 = b & 0b00001111
        outputStream.write(table[Int(nibble1)])
        outputStream.write(table[Int(nibble2)])
    }
}

/**
Decode a sequence of hexidecimal ASCII/UTF-8 characters to a [UInt8].
The input string must contain an even number valid characters (0-9, a-f, and A-F).

- parameter str: String to decode. Should be characters 0-9, a-f, and A-F.
- returns: (byte array, true) on success, ([], false) on failure due to invalid character or odd number of input characters.
*/
public func DecodeUTF8Sequence<UTF8Sequence : Sequence> (_ sequence : UTF8Sequence) -> ([UInt8], Bool) where UTF8Sequence.Iterator.Element == UInt8 {
    // ASCII values
    let uppercaseA = UInt8(65)
    let uppercaseF = UInt8(70)
    let lowercaseA = UInt8(97)
    let lowercaseF = UInt8(102)
    let zero = UInt8(48)
    let nine = UInt8(57)
    
    var nibbles = [UInt8]()
    nibbles.reserveCapacity(2)
    
    var result = [UInt8]()
    
    for codeUnit in sequence {
        if codeUnit >= uppercaseA && codeUnit <= uppercaseF {
            nibbles.append(10 + codeUnit - uppercaseA)
        } else if codeUnit >= lowercaseA && codeUnit <= lowercaseF {
            nibbles.append(10 + codeUnit - lowercaseA)
        } else if codeUnit >= zero && codeUnit <= nine {
            nibbles.append(codeUnit - zero)
        } else {
            return ([], false)
        }
        if nibbles.count == 2 {
            let byte = (nibbles[0] << 4) | nibbles[1]
            result.append(byte)
            nibbles.removeAll(keepingCapacity: true)
        }
    }
    if nibbles.count != 0 {
        return ([], false)
    }
    return (result, true)
}

// Table to encode bytes with lowercase hexidecimal characters.
private let lowercaseTable : [String] = [
    "0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"
]

// Table to encode bytes with uppercase hexidecimal characters.
private let uppercaseTable : [String] = [
    "0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"
]
