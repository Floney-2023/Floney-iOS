//
//  ProfileManager.swift
//  Floney
//
//  Created by 남경민 on 2023/07/19.
//

import Foundation

enum UserProfileImageState : String {
    case `default` = "default"
    case random1 = "random1"
    case random2 = "random2"
    case random3 = "random3"
    case random4 = "random4"
    case random5 = "random5"
    case random6 = "random6"
    case custom = "custom"
}
enum BookProfileImageState : String {
    case `default` = "default"
    case custom = "custom"
}
class ProfileManager: ObservableObject {
    static let shared = ProfileManager()  // Singleton instance
    @Published var userImageState: UserProfileImageState = .default
    @Published var bookImageState: BookProfileImageState = .default
    init() {
        
    }
    
    func getUserProfileImageState() -> UserProfileImageState {
        guard let imageState = Keychain.getKeychainValue(forKey: .userProfileState) else {
            userImageState = .default
            Keychain.setKeychain(userImageState.rawValue, forKey: .userProfileState)
            return userImageState
        }
        if let userState = UserProfileImageState(rawValue: imageState) {
            userImageState = userState
        }
        return userImageState
    }
    func getBookProfileImageState() -> BookProfileImageState {
        guard let imageState = Keychain.getKeychainValue(forKey: .bookProfileState) else {
            bookImageState = .default
            Keychain.setKeychain(bookImageState.rawValue, forKey: .bookProfileState)
            return bookImageState
        }
        if let bookState = BookProfileImageState(rawValue: imageState) {
            bookImageState = bookState
        }
        return bookImageState
    }

    func setUserImageStateToCustom(url: String) {
        userImageState = .custom
        Keychain.setKeychain(userImageState.rawValue, forKey: .userProfileState)
        Keychain.setKeychain(url, forKey: .userProfileImage)

    }
    func setBookImageStateToCustom(url: String) {
        bookImageState = .custom
        Keychain.setKeychain(bookImageState.rawValue, forKey: .bookProfileState)
        Keychain.setKeychain(url, forKey: .bookProfileImage)
    }
    func setRandomProfileImage() {
        // 여기에서 랜덤 이미지를 선택하고 imageState를 업데이트합니다.
        let randomNumber = Int.random(in: 1...6)
        switch randomNumber {
        case 1:
            userImageState = .random1
        case 2:
            userImageState = .random2
        case 3:
            userImageState = .random3
        case 4:
            userImageState = .random4
        case 5:
            userImageState = .random5
        case 6:
            userImageState = .random6
        default:
            userImageState = .random1
        }
        Keychain.setKeychain(userImageState.rawValue, forKey: .userProfileState)
    }
    
    private func saveUserImageURLToKeychain(_ imageUrl: String) {
        // 이미지 URL을 키체인에 저장하는 로직
    }
}
