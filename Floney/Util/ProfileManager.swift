//
//  ProfileManager.swift
//  Floney
//
//  Created by 남경민 on 2023/07/19.
//

import Foundation
import SwiftUI

enum UserProfileImageState : String {
    case `default` = "default"
    case random0 = "random0"
    case random1 = "random1"
    case random2 = "random2"
    case random3 = "random3"
    case random4 = "random4"
    case random5 = "random5"
    case custom = "custom"
}
enum BookProfileImageState : String {
    case `default` = "default"
    case custom = "custom"
}
class ProfileManager: ObservableObject {
    static let shared = ProfileManager()  // Singleton instance
    @Published var userImageState: UserProfileImageState = .default
    //@Published var userPreviewImageCustom : UIImage?
    @Published var userPreviewImage124 : UIImage?
    @Published var userPreviewImage36 : UIImage?
    @Published var userPreviewImage32 : UIImage?
    @Published var userImageUrl : String = ""
    @Published var bookImageState: BookProfileImageState = .default
    @Published var bookImageUrl : String = ""
    @Published var bookPreviewImage : UIImage?
    
    func getUserProfileImageState() -> UserProfileImageState {
        /*
        guard let imageState = Keychain.getKeychainValue(forKey: .userProfileState) else {
            userImageState = .default
            //Keychain.setKeychain(userImageState.rawValue, forKey: .userProfileState)
            return userImageState
        }
        if let userState = UserProfileImageState(rawValue: imageState) {
            userImageState = userState
        }*/
        return userImageState
    }
    
    func getBookProfileImageState() -> BookProfileImageState {
        /*
        guard let imageState = Keychain.getKeychainValue(forKey: .bookProfileState) else {
            bookImageState = .default
            Keychain.setKeychain(bookImageState.rawValue, forKey: .bookProfileState)
            return bookImageState
        }
        if let bookState = BookProfileImageState(rawValue: imageState) {
            bookImageState = bookState
        }*/
        return bookImageState
    }

    func setUserImageStateToCustom(urlString: String) {
        userImageState = .custom
        //Keychain.setKeychain(userImageState.rawValue, forKey: .userProfileState)
        //Keychain.setKeychain(url, forKey: .userProfileImage)
        userImageUrl = urlString
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.userPreviewImage124 = image
                    self.userPreviewImage36 = image
                    self.userPreviewImage32 = image
                }
            } else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()

    }
    func setUserImageStateToDefault() {
        userImageState = .default
        //Keychain.setKeychain(userImageState.rawValue, forKey: .userProfileState)
        self.userPreviewImage124 = UIImage(named: "user_profile_124")
        self.userPreviewImage36 = UIImage(named: "user_profile_36")
        self.userPreviewImage32 = UIImage(named: "user_profile_32")
    }

    func setBookImageStateToDefault() {
        bookImageState = .default
        //Keychain.setKeychain(bookImageState.rawValue, forKey: .bookProfileState)
        
    }
    
    func setBookImageStateToCustom(urlString: String) {
        bookImageState = .custom
        //Keychain.setKeychain(bookImageState.rawValue, forKey: .bookProfileState)
        //Keychain.setKeychain(url, forKey: .bookProfileImage)
        bookImageUrl = urlString
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.bookPreviewImage = image
                }
            } else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
    
    func setRandomProfileImage(randomNumStr : String) {
        switch randomNumStr {
        case "random0" :
            userImageState = .random0
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_01_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_01_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_01_32")
        case "random1" :
            userImageState = .random1
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_02_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_02_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_02_32")

        case "random2":
            userImageState = .random2
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_03_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_03_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_03_32")

        case "random3":
            userImageState = .random3
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_04_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_04_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_04_32")

        case "random4":
            userImageState = .random4
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_05_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_05_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_05_32")

        case "random5":
            userImageState = .random5
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_06_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_06_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_06_32")

        default:
            userImageState = .random0
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_01_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_01_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_01_32")

        }
    }
    
}
