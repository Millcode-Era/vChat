//
//  WrappedAES.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/28.
//

import Foundation
import SwCrypt

/// Advanced Encryption Standard
final class AES {
    fileprivate static func encrypt(
        data: AESRawValue,
        key: AESKey,
        iv: AESIV,
        blockMode: CC.BlockMode = .cbc,
        padding: CC.Padding = .pkcs7Padding
    ) throws -> AESEncryptedValue {
        let data = try CC.crypt(.encrypt, blockMode: blockMode, algorithm: .aes, padding: padding, data: data.rawValue, key: key.rawValue, iv: iv.rawValue)
        return AESEncryptedValue(data)
    }
    
    fileprivate static func decrypt(
        data: AESEncryptedValue,
        key: AESKey,
        iv: AESIV,
        blockMode: CC.BlockMode = .cbc,
        padding: CC.Padding = .pkcs7Padding
    ) throws -> AESRawValue {
        let data = try CC.crypt(.decrypt, blockMode: blockMode, algorithm: .aes, padding: padding, data: data.rawValue, key: key.rawValue, iv: iv.rawValue)
        return AESRawValue(data)
    }
    
    /// Generate AES key from string
    /// Modified code from Plan-V Studio
    /// - Parameters:
    ///   - password: Plain password
    ///   - length: key length
    /// - Returns: AES key with specific lenght
    static func getAESPassword(password: String, length: Int) -> Data {
        let sha512String = password.sha512
        let data = sha512String.data(using: .utf8)!
        let offset = Int(data[0]) % (sha512String.count - length * 2)
        var subString = sha512String.dropFirst(offset).prefix(length * 2)
        var result = [UInt8]()
        while !subString.isEmpty {
            let sub = subString.prefix(2)
            result.append(UInt8(sub, radix: 16)!)
            subString = subString.dropFirst(2)
        }
        return Data(result)
    }
    
    /// Generate AES iv from string
    /// Modified code from Plan-V Studio
    /// - Parameter password: Plain password
    /// - Returns: AES iv
    static func getAESIV(password: String) -> Data {
        let length = 16
        let sha512String = password.sha512
        let data = sha512String.data(using: .utf8)!
        let offset = Int(data.last!) % (sha512String.count - length * 2)
        var subString = sha512String.dropFirst(offset).prefix(length * 2)
        var result = [UInt8]()
        while !subString.isEmpty {
            let sub = subString.prefix(2)
            result.append(UInt8(sub, radix: 16)!)
            subString = subString.dropFirst(2)
        }
        return Data(result)
    }
}

struct AESKey {
    private var data: Data
    
    init?(_ data: Data) {
        if [16, 24, 32].contains(data.count) {
            self.data = data
        } else {
            return nil
        }
    }
    
    init?(_ password: String, length: Int = 32) {
        if ![16, 24, 32].contains(length) {
            return nil
        }
        self.data = AES.getAESPassword(password: password, length: length)
    }
    
    init(fromHexString hexString: String, length: Int = 32) throws {
        if hexString.count != length * 2 {
            throw AESError.unmatchedLength(length)
        }
        var hexString = hexString
        var result = [UInt8]()
        while !hexString.isEmpty {
            let sub = hexString.prefix(2)
            guard let byte = UInt8(sub, radix: 16) else {
                throw AESError.unexpectedHexString(String(sub))
            }
            result.append(byte)
            hexString = String(hexString.dropFirst(2))
        }
        self.data = Data(result)
    }
    
    init?(base64Encoded string: String) {
        if let data = Data(base64Encoded: string) {
            self.data = data
        }
        return nil
    }
}
extension AESKey {
    var rawValue: Data {
        data
    }
    
    func toHexString() -> String {
        var result = ""
        self.rawValue.forEach { element in
            result += String(format: "%02x", element)
        }
        return result
    }
    
    func base64EncodedString() -> String {
        self.rawValue.base64EncodedString()
    }
}

struct AESIV {
    private var data: Data
    
    init?(_ data: Data) {
        if data.count == 16 {
            self.data = data
        } else {
            return nil
        }
    }
    
    init?(_ password: String) {
        self.data = AES.getAESIV(password: password)
    }
    
    init(fromHexString hexString: String, length: Int = 16) throws {
        if hexString.count != length * 2 {
            throw AESError.unmatchedLength(length)
        }
        var hexString = hexString
        var result = [UInt8]()
        while !hexString.isEmpty {
            let sub = hexString.prefix(2)
            guard let byte = UInt8(sub, radix: 16) else {
                throw AESError.unexpectedHexString(String(sub))
            }
            result.append(byte)
            hexString = String(hexString.dropFirst(2))
        }
        self.data = Data(result)
    }
    
    init?(base64Encoded string: String) {
        if let data = Data(base64Encoded: string) {
            self.data = data
        }
        return nil
    }
}
extension AESIV {
    var rawValue: Data {
        data
    }
    
    func toHexString() -> String {
        var result = ""
        self.rawValue.forEach { element in
            result += String(format: "%02x", element)
        }
        return result
    }
    
    func base64EncodedString() -> String {
        self.rawValue.base64EncodedString()
    }
}

struct AESRawValue {
    private var data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    init(_ string: String) {
        self.data = string.data(using: .utf8)!
    }
}
extension AESRawValue {
    var rawValue: Data {
        data
    }
    
    var toString: String? {
        String(data: rawValue, encoding: .utf8)
    }
    
    var toData: Data {
        rawValue
    }
    
    func encrypt(
        key: AESKey,
        iv: AESIV,
        blockMode: CC.BlockMode = .cbc,
        padding: CC.Padding = .pkcs7Padding
    ) throws -> AESEncryptedValue {
        try AES.encrypt(data: self, key: key, iv: iv, blockMode: blockMode, padding: padding)
    }
}

struct AESEncryptedValue {
    private var data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    /// Generate AES excrypted value from Base-64 encoded string
    /// - Parameters:
    ///   - base64Encoded: Base-64 encoded string
    ///   - options: The options to use for the decoding. Default value is [].
    init?(base64Encoded: String, options: Data.Base64DecodingOptions = []) {
        if let data = Data(base64Encoded: base64Encoded, options: options) {
            self.data = data
        } else {
            return nil
        }
    }
}
extension AESEncryptedValue {
    var rawValue: Data {
        data
    }
    
    /// Return a Base-64 Encoded AES encrypted value
    /// - Parameter options: The options to use for the encoding. Default value is [].
    /// - Returns: Base-64 encoded AES encrypted value
    func base64EncodedString(options: Data.Base64EncodingOptions = []) -> String {
        rawValue.base64EncodedString(options: options)
    }
    
    func decrypt(
        key: AESKey,
        iv: AESIV,
        blockMode: CC.BlockMode = .cbc,
        padding: CC.Padding = .pkcs7Padding
    ) throws -> AESRawValue {
        try AES.decrypt(data: self, key: key, iv: iv, blockMode: blockMode, padding: padding)
    }
}

enum AESError: Error {
    case unmatchedLength(Int), unexpectedHexString(String)
}
