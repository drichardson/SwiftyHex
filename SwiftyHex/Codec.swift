//
//  Codec.swift
//  SwiftyHex
//
//  Created by Doug Richardson on 8/25/15.
//  Copyright (c) 2015 Doug Richardson. All rights reserved.
//

import Foundation

public enum EncodingOutput {
    case Uppercase
    case Lowercase
}

private let lowercaseTable : [Character] = [
    Character("0"),
    Character("1"),
    Character("2"),
    Character("3"),
    Character("4"),
    Character("5"),
    Character("6"),
    Character("7"),
    Character("8"),
    Character("9"),
    Character("a"),
    Character("b"),
    Character("c"),
    Character("d"),
    Character("e"),
    Character("f"),
]

private let uppercaseTable : [Character] = [
    Character("0"),
    Character("1"),
    Character("2"),
    Character("3"),
    Character("4"),
    Character("5"),
    Character("6"),
    Character("7"),
    Character("8"),
    Character("9"),
    Character("A"),
    Character("B"),
    Character("C"),
    Character("D"),
    Character("E"),
    Character("F"),
]

/**
Encode a [UInt8] byte array as a hexidecimal String.

:param: bytes Bytes to encode.
:param: output Output uppercase or lowercase hex
:returns: A String of the encoded bytes.
*/
public func Encode(bytes : [UInt8], output : EncodingOutput = .Lowercase) -> String {
    var result = String()
    result.reserveCapacity(bytes.count * 2)
    
    let table : [Character]
    switch output {
    case .Lowercase:
        table = lowercaseTable
    case .Uppercase:
        table = uppercaseTable
    }
    
    for b in bytes {
        let nibble1 = (b & 0b11110000) >> 4
        let nibble2 = b & 0b00001111
        result.append(table[Int(nibble1)])
        result.append(table[Int(nibble2)])
    }
    
    return result
}

/**
Decode a hexidecimal String to a [UInt8]. The input string must contain
an even number valid characters (0-9, a-f, and A-F).

:param: str String to decode. Should be characters 0-9, a-f, and A-F.
:returns: (byte array, true) on success, ([], false) on failure due to invalid character or odd number of input characters.
*/
public func Decode(str : String) -> ([UInt8], Bool) {
    let utf8 = str.utf8
    
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
    
    for codeUnit in utf8 {
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
            nibbles.removeAll(keepCapacity: true)
        }
    }
    if nibbles.count != 0 {
        return ([], false)
    }
    return (result, true)
}
