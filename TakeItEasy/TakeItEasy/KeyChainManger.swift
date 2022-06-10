//
//  KeyChainManger.swift
//  TakeItEasy
//
//  Created by admin on 6/10/22.
//

import Foundation


class KeyChainManger{
    enum KeychainError: Error{
        case duplicateEntry
        case unkown(OSStatus)
    }
    static func save(
        service: String,
        account: String,
        password: Data
        ) throws{
        //service account password class
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword ,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]
            
           let status = SecItemAdd(query as CFDictionary, nil)
            
            guard status != errSecDuplicateItem else {
                throw KeychainError.duplicateEntry
            }
            
            guard status == errSecSuccess else {
                throw KeychainError.unkown(status)
            }
            
            print("saved")
    }
    static func get(
        service: String,
        account: String
    )  -> Data?{
        //service account class return data
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print(status)
        
        return result as? Data
    }
    
    
}
