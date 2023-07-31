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
    @Published var bookPreviewImage124 : UIImage?
    @Published var bookPreviewImage110 : UIImage?
    @Published var bookPreviewImage36 : UIImage?
    @Published var bookPreviewImage34 : UIImage?
    //@Published var bookPreviewImage32 : UIImage?

    @Published var userImageUrl : String = ""
    @Published var bookImageState: BookProfileImageState = .default
    @Published var bookImageUrl : String = ""
    //@Published var bookPreviewImage : UIImage?
    
    func getUserProfileImageState() -> UserProfileImageState {
        return userImageState
    }
    
    func getBookProfileImageState() -> BookProfileImageState {
        return bookImageState
    }

    func setUserImageStateToCustom(urlString: String) {
        userImageState = .custom
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
  
        self.userPreviewImage124 = UIImage(named: "user_profile_124")
        self.userPreviewImage36 = UIImage(named: "user_profile_36")
        self.userPreviewImage32 = UIImage(named: "user_profile_32")
    }

    func setBookImageStateToDefault() {
        bookImageState = .default
        
        self.bookPreviewImage124 = UIImage(named: "book_profile_124")
        self.bookPreviewImage110 = UIImage(named: "book_profile_110")
        self.bookPreviewImage36 = UIImage(named: "book_profile_36")
        self.bookPreviewImage34 = UIImage(named: "book_profile_34")
       // self.bookPreviewImage32 = UIImage(named: "book_profile_32")
    }
    
    func setBookImageStateToCustom(urlString: String) {
        bookImageState = .custom
        bookImageUrl = urlString
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.bookPreviewImage124 = image
                    self.bookPreviewImage110 = image
                    self.bookPreviewImage36 = image
                    self.bookPreviewImage34 = image
                    //self.bookPreviewImage32 = image
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
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_00_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_00_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_00_32")
        case "random1" :
            userImageState = .random1
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_01_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_01_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_01_32")

        case "random2":
            userImageState = .random2
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_02_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_02_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_02_32")

        case "random3":
            userImageState = .random3
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_03_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_03_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_03_32")

        case "random4":
            userImageState = .random4
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_04_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_04_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_04_32")

        case "random5":
            userImageState = .random5
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_05_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_05_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_05_32")

        default:
            userImageState = .random0
            self.userPreviewImage124 = UIImage(named: "img_user_random_profile_00_124")
            self.userPreviewImage36 = UIImage(named: "img_user_random_profile_00_36")
            self.userPreviewImage32 = UIImage(named: "img_user_random_profile_00_32")

        }
    }
    
}
