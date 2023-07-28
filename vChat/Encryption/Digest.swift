//
//  Digest.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/28.
//

import Foundation
import CryptoKit

extension String {
    var sha512: String {
        let data = self.data(using: .utf8)!
        let digest = SHA512.hash(data: data)
        
        var result = ""
        digest.forEach { element in
            result += String(format: "%02x", element)
        }
        return result
    }
    
    var sha256: String {
        let data = self.data(using: .utf8)!
        let digest = SHA256.hash(data: data)
        
        var result = ""
        digest.forEach { element in
            result += String(format: "%02x", element)
        }
        return result
    }
}
