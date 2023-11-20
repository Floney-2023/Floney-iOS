//
//  RecentBookKeyManager.swift
//  Floney
//
//  Created by 남경민 on 2023/09/06.
//

import Foundation
import Alamofire

class RecentBookKeyManager {
    func saveRecentBookKey(bookKey: String) {
        let url = "\(Constant.BASE_URL)/users/bookKey"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        let parameters = RecentBookKeyRequest(bookKey: bookKey)
        print(url)
        print(parameters)
        print(token)
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer \(token)"])
        .response { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    print("Failed to retrieve the status code.")
                    return
                }
                
                if statusCode == 200 {
                    print("change recent book Success")
                    /*
                    if Keychain.getKeychainValue(forKey: .bookStatus) == "ACTIVE" {
                        BookExistenceViewModel.shared.bookDisabled = false
                    } else {
                        BookExistenceViewModel.shared.bookDisabled = true
                    }*/
                } else {
                    // Optionally, handle other status codes or decode error from the response
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0) }
                    print("Error in success with status code other than 200: \(backendError)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
            
        }
        
    }
}

struct RecentBookKeyRequest : Encodable {
    let bookKey : String
}
