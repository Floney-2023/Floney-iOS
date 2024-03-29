//
//  KeyChain.swift
//  Floney
//
//  Created by 남경민 on 2023/05/07.
//

import Foundation
import SwiftKeychainWrapper

class Keychain {
    enum KeychainKey: String {
        case accessToken
        case refreshToken
        case email
        case password
        case bookKey
        case bookCode
        case userNickname
        case bookName
        case fcmToken
        case appleUserId
        case appleEmail
        case appleName
        case provider
        //case bookStatus
    }
    
    /**
     # setKeychain
     - parameters:
     - value : 저장할 값
     - keychainKey : 저장할 value의  Key - (E) Common.KeychainKey
     - Authors: zoe
     - Note: 키체인에 값을 저장하는 공용 함수
     */
    static func setKeychain(_ value: String, forKey keychainKey: KeychainKey) {
        KeychainWrapper.standard.set(value, forKey: keychainKey.rawValue)
    }
    
    /**
     # getKeychainValue
     - parameters:
     - keychainKey : 반환할 value의 Key - (E) Common.KeychainKey
     - Authors: zoe
     - Note: 키체인 값을 반환하는 공용 함수
     */
    static func getKeychainValue(forKey keychainKey: KeychainKey) -> String? {
        return KeychainWrapper.standard.string(forKey: keychainKey.rawValue)
    }
    
    static func setDataTypeKey(_ value: Data, forKey keychainKey: KeychainKey) {
        KeychainWrapper.standard.set(value, forKey: keychainKey.rawValue)
    }
    static func getDataTypeKey(forKey keychainKey: KeychainKey) -> Data? {
        return KeychainWrapper.standard.data(forKey: keychainKey.rawValue)
    }
    /**
     # removeKeychain
     - parameters:
     - keychainKey : 삭제할 value의  Key - (E) Common.KeychainKey
     - Authors: zoe
     - Note: 키체인 값을 삭제하는 공용 함수
     */
    static func removeKeychain(forKey keychainKey: KeychainKey) {
        KeychainWrapper.standard.removeObject(forKey: keychainKey.rawValue)
    }
}
