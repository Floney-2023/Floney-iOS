//
//  CurrencyManager.swift
//  Floney
//
//  Created by 남경민 on 2023/09/06.
//

import Foundation
import Alamofire
import Combine
class CurrencyManager: ObservableObject {
    static let shared = CurrencyManager()
    var fcmManager = FCMDataManager()
    @Published var currentCurrencyUnit: String = "KRW"
    @Published var currentCurrency : String = "원"
    @Published var hasDecimalPoint : Bool = false
    
    func getCurrency() {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let url = "\(Constant.BASE_URL)/books/info/currency?bookKey=\(bookKey)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        
        print(url)
        print(token)
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["Authorization": "Bearer \(token)"])
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(SetCurrencyResponse.self, from: data)
                    let currencyCode = decodedResponse.myBookCurrency
                    print("Currency Code:", currencyCode)
                    
                    self.currentCurrencyUnit = currencyCode
                    self.currencySymbol()
                                        // 필요한 다른 작업 수행
                } catch {
                    print("Failed to decode:", error.localizedDescription)
                }
                
            case .failure(let error):
                print("Request error:", error)
            }
        }
    }
    
    func currencySymbol() {
        switch currentCurrencyUnit {
        case "KRW":
            currentCurrency = "원"
            hasDecimalPoint = false
        case "USD":
            currentCurrency = "$"
            hasDecimalPoint = true
        case "EUR":
            currentCurrency = "€"
            hasDecimalPoint = true
        case "JPY":
            currentCurrency = "¥"
            hasDecimalPoint = false
        case "CNY":
            currentCurrency = "¥"
            hasDecimalPoint = false
        case "GBP":
            currentCurrency = "£"
            hasDecimalPoint = true
        default:
            currentCurrency = "원"  // 혹은 기본값으로 다른 문자열을 반환
            hasDecimalPoint = false
        }
        
        print("Currency :", currentCurrency)
        print("has decimal point :", hasDecimalPoint)
    }
    
}
