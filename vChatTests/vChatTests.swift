//
//  vChatTests.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/25.
//

import XCTest
@testable import vChat

final class vChatTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAES() throws {
        var text = "Hello, world!"
        for _ in 1...1000000 {
            text += "Hello, world!"
        }
        let password = "this is a password"
        let key = AESKey(password)
        let iv = AESIV(password)
        let raw = AESRawValue(text)
        let encrypted = try raw.encrypt(key: key!, iv: iv!)
        XCTAssert(encrypted != nil)
        let decrypted = try encrypted.decrypt(key: key!, iv: iv!)
        XCTAssert(decrypted.rawValue == raw.rawValue)
    }
    
    
    func testAESPerformance() throws {
        self.measure {
            try! testAES()
        }
    }
    
    func testAESMethods() throws {
        let password = "psw"
        let key = AESKey(password)
        let hex = key?.toHexString()
        let key2 = try AESKey(fromHexString: hex!)
        XCTAssert(key?.rawValue == key2.rawValue)
        
        let iv = AESIV(password)
        let hexiv = iv?.toHexString()
        let iv1 = try AESIV(fromHexString: hexiv!)
        XCTAssert(iv?.rawValue == iv1.rawValue)
    }
    
    func testDigest() throws {
        let text = "test"
        XCTAssert(text.sha256 == "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08")
        XCTAssert(text.sha512 == "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff")
    }
}
