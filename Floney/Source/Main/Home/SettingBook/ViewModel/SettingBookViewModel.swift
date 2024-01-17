//
//  SettingBookViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/06/30.
//

import Foundation
import Combine
import SwiftUI
import FirebaseFirestore
enum BudgetAssetType {
    case budget
    case asset
}
class SettingBookViewModel : ObservableObject {
#if DEBUG
    let projectMode = "dev"
#else
    let projectMode = "prod"
#endif
    var fcmManager = FCMDataManager()
    @Published var tokenViewModel = TokenReissueViewModel()
    @Published var ChangeProfileImageSuccess = false
    @Published var bookInfoLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var shareUrl : String?
    
    @Published var bookKey = ""
    
    @Published var result : BookInfoResponse = BookInfoResponse(bookImg: nil, bookName: "", startDay: "", seeProfileStatus: true, carryOver: true, ourBookUsers: [])
    @Published var bookUsers : [BookUsers] = []
    @Published var bookImg : String?
    @Published var bookName = "" {
        didSet {
            if bookName.count > 10 {
                bookName = String(bookName.prefix(10))
            }
        }
    }
    @Published var startDay = ""
    @Published var carryOver = true
    @Published var stateOfCarryOver = false
    @Published var changedName = "" {
        didSet {
            if changedName.count > 10 {
                changedName = String(changedName.prefix(10))
            }
        }
    }
    @Published var encryptedImageUrl : String = ""
    @Published var profileStatus = true {
        didSet {
            self.changeProfileStatus()
        }
    }
    
    @Published var asset : Double = 0
    
    @Published var role = "방장"
    
    @Published var bookPreviewImage124: UIImage?
    @Published var bookPreviewImage34: UIImage?
    @Published var bookPreviewImage36: UIImage?
    @Published var userImages : [String]?
    
    @Published var bookCode : String = ""
    
    @Published var currency : String = CurrencyManager.shared.currentCurrencyUnit
    
    //MARK: Excel
    @Published var excelURL : URL?
    @Published var shareExcelStatus = false
    @Published var selectedExcelDuration : ExcelDurationType = ExcelDurationType.all
    let durationOptions = ["이번달", "저번달", "올해", "작년","전체"]
    let durationMapping: [String: ExcelDurationType] = [
        "이번달": .thisMonth,
        "저번달": .lastMonth,
        "올해": .oneYear,
        "작년": .lastYear,
        "전체": .all
    ]
    //MARK: Budget
    @Published var budget : Double = 0
    @Published var yearlyData: [Int: [MonthlyAmount]] = [:]
    @Published var selectedYear: Int = Calendar.current.component(.year, from: Date()) {
        didSet {
            getBudget()
        }
    }
    @Published var budgetDate = ""
    @Published var currentBudget : String = ""
    
    @Published var initialAsset: Double = 0
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    var dataManager: SettingBookProtocol
    
    var assetDataManager : AnalysisProtocol = AnalysisService.shared
    
    init( dataManager: SettingBookProtocol = SettingBookService.shared) {
        self.dataManager = dataManager
        getBudget()
    }
    func getYearlyBudget() {
        yearlyData[selectedYear] = [
            MonthlyAmount(month: 1, amount: 0),
            MonthlyAmount(month: 2, amount: 0),
            MonthlyAmount(month: 3, amount: 0),
            MonthlyAmount(month: 4, amount: 0),
            MonthlyAmount(month: 5, amount: 0),
            MonthlyAmount(month: 6, amount: 0),
            MonthlyAmount(month: 7, amount: 0),
            MonthlyAmount(month: 8, amount: 0),
            MonthlyAmount(month: 9, amount: 0),
            MonthlyAmount(month: 10, amount: 0),
            MonthlyAmount(month: 11, amount: 0),
            MonthlyAmount(month: 12, amount: 0)
        ]
    }
    func getBudget() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let date = "\(selectedYear)-01-01"
        let request = GetBudgetRequest(bookKey: bookKey, date: date)
        dataManager.getBudget(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getBudget()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    print("--성공--")
                    let result = dataResponse.value
                    self.yearlyData[self.selectedYear] = [
                        MonthlyAmount(month: 1, amount: result?.JANUARY ?? 0),
                        MonthlyAmount(month: 2, amount: result?.FEBRUARY ?? 0),
                        MonthlyAmount(month: 3, amount: result?.MARCH ?? 0),
                        MonthlyAmount(month: 4, amount: result?.APRIL ?? 0),
                        MonthlyAmount(month: 5, amount: result?.MAY ?? 0),
                        MonthlyAmount(month: 6, amount: result?.JUNE ?? 0),
                        MonthlyAmount(month: 7, amount: result?.JULY ?? 0),
                        MonthlyAmount(month: 8, amount: result?.AUGUST ?? 0),
                        MonthlyAmount(month: 9, amount: result?.SEPTEMBER ?? 0),
                        MonthlyAmount(month: 10, amount: result?.OCTOBER ?? 0),
                        MonthlyAmount(month: 11, amount: result?.NOVEMBER ?? 0),
                        MonthlyAmount(month: 12, amount: result?.DECEMBER ?? 0)
                    ]
                }
            }.store(in: &cancellableSet)
    }
    func getAssetResponse(request: BudgetAssetRequest) async -> Result<AssetResponse, Error> {
        await withCheckedContinuation { continuation in
            self.assetDataManager.analysisAsset(request)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(returning: .failure(error))
                    case .finished:
                        break
                    }
                } receiveValue: { response in
                    switch response.result {
                    case .success(let assetResponse):
                        continuation.resume(returning: .success(assetResponse))
                    case .failure(let error):
                        continuation.resume(returning: .failure(error))
                    }
                }
                .store(in: &self.cancellableSet)
        }
    }
                   
    func getAsset() async -> Double {
        let selectedDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
        var date = ""
        if let year = components.year, let month = components.month {
            date = "\(year)-\(String(format: "%02d", month))-01"
        }
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BudgetAssetRequest(bookKey: bookKey, date: date)

        do {
            let result = await getAssetResponse(request: request)
            switch result {
            case .success(let assetResponse):
                return assetResponse.initAsset ?? 0
            case .failure(let error):
                print("네트워크 요청 실패: \(error)")
                return 0
            }
        } catch {
            print("에러 발생: \(error)")
            return 0
        }
    }


    //MARK: server
    func getBookInfo() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookInfoRequest(bookKey: bookKey)
        dataManager.getBookInfo(request)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getBookInfo()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    print("--성공--")
                    print(self.result)
                    
                    self.bookUsers = self.result.ourBookUsers
                    self.bookUsers.sort {
                        if $0.me != $1.me {
                            return $0.me
                        } else {
                            // Here you can return the secondary criteria if `me` is equal.
                            // For instance, you can sort by name.
                            return $0.name < $1.name
                        }
                    }
                    self.bookImg = self.result.bookImg
                    self.bookName = self.result.bookName
                    self.startDay = self.result.startDay
                    self.carryOver = self.result.carryOver
                    self.profileStatus = self.result.seeProfileStatus
                    Keychain.setKeychain(self.bookName, forKey: .bookName)
                    self.hostFilter()
                    
                    self.userImages = self.bookUsers.compactMap { $0.profileImg }
                    
                    if let url = self.bookImg {
                        //let decryptedUrl = self.cryprionManager.decrypt(url, using: self.cryprionManager.key!)
                        ProfileManager.shared.setBookImageStateToCustom(urlString: url)
                    } else {
                        ProfileManager.shared.setBookImageStateToDefault()
                    }
                    self.loadBookPreviewImage()
                }
            }.store(in: &cancellableSet)
    }
    
    func changeProfile(inputStatus: String) {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        var request : BookProfileRequest
        if inputStatus == "default" {
            request = BookProfileRequest(newUrl: nil, bookKey: bookKey)
        } else {
            request = BookProfileRequest(newUrl: encryptedImageUrl, bookKey: bookKey)
        }
        
        print("book profile parameter : \(request)")
        dataManager.changeProfile(parameters: request)
            .sink { completion in
                
                switch completion {
                case .finished:
                    print("Profile successfully changed.")
                    
                    DispatchQueue.main.async {
                        LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                    }
                    self.ChangeProfileImageSuccess = true
                    
                    if inputStatus == "default" {
                        ProfileManager.shared.setBookImageStateToDefault()
                    } else {
                        ProfileManager.shared.setBookImageStateToCustom(urlString: self.encryptedImageUrl)
                    }
                    DispatchQueue.main.async {
                        AlertManager.shared.update(showAlert: true, message: "변경이 완료되었습니다.", buttonType: .green)
                    }
                    
                case .failure(let error):
                    print("Error changing profile: \(error)")
                    self.createAlert(with: error, retryRequest: {
                        self.changeProfile(inputStatus: inputStatus)
                    })
                    DispatchQueue.main.async {
                        LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                    }
                    
                }
            } receiveValue: { [weak self] data in
                guard let self = self else {return}
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func changeNickname() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookNameRequest(name: changedName, bookKey: bookKey)
        dataManager.changeNickname(parameters: request)
            .sink { [weak self] completion in
                guard let self = self else {return}
                
                switch completion {
                case .finished:
                    print("Changing nickname successfully changed.")
                    AlertManager.shared.update(showAlert: true, message: "변경이 완료되었습니다.", buttonType: .green)
                    bookName = changedName
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.changeNickname()
                    })
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func isValidChangedName() -> Bool {
        if changedName.isEmpty {
            AlertManager.shared.handleError(InputValidationError.emptyBookName)
            return false
        }
        return true
    }
    func changeProfileStatus() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = SeeProfileRequest(bookKey: bookKey, seeProfileStatus: profileStatus)
        dataManager.changeProfileStatus(parameters: request)
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    print("Changing Profile Status successfully changed.")
                case .failure(let error):
                    print("Error changing profile status: \(error)")
                    self.createAlert(with: error, retryRequest: {
                        self.changeProfileStatus()
                    })
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    // 예산 설정
    func setBudget() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        
        let request = SetBudgetRequest(bookKey: bookKey, budget: budget, date: budgetDate)
        dataManager.setBudget(parameters: request)
            .sink { [weak self] completion in
                guard let self = self else {return}
                
                switch completion {
                case .finished:
                    print("Setting Budget successfully changed.")
                    AlertManager.shared.update(showAlert: true, message: "변경이 완료되었습니다.", buttonType: .green)
                    self.getBudget()
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.setBudget()
                    })
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    
    // 예산 date
    func setBudgetDate(month: Int) {
        if month < 10 {
            self.budgetDate = "\(selectedYear)-0\(month)-01"
        } else if month >= 10 {
            self.budgetDate = "\(selectedYear)-\(month)-01"
        }
        if let mayAmount = self.yearlyData[self.selectedYear]?.first(where: { $0.month == month }) {
            let amount = mayAmount.amount
            if amount > 0 {
                self.currentBudget = amount.formattedString
            } else {
                self.currentBudget = ""
            }
        } else {
            // 해당 월에 대한 데이터가 없는 경우의 처리
            
        }
        print(self.currentBudget)
    }
    
    func onlyNumberValid(input: String, budgetAssetType : BudgetAssetType) -> Bool {
        print("예산 인풋 : \(input)")
        let newValue = input.replacingOccurrences(of: ",", with: "")

        if let doubleValue = Double(newValue) {
            // 변환 성공
            print("변환 성공")
            print(doubleValue) // 출력: 3200.4
            if budgetAssetType == .budget {
                budget = doubleValue
                setBudget()
            } else {
                asset = doubleValue
                setAsset()
            }
            return true
        } else {
            // 변환 실패
            print("변환 실패")
            AlertManager.shared.handleError(InputValidationError.onlyNumberValid)
            return false
        }
        return false
    }
    
    func setAsset() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = SetAssetRequest(bookKey: bookKey, asset: asset)
        dataManager.setAsset(parameters: request)
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    print("Setting Asset successfully changed.")
                    AlertManager.shared.update(showAlert: true, message: "변경이 완료되었습니다.", buttonType: .green)
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.setAsset()
                    })
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    
    func setCarryOver(status : Bool)  {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = SetCarryOver(bookKey: bookKey, status: status)
        dataManager.setCarryOver(parameters: request)
            .sink { [weak self] completion in
                guard let self = self else {return}
                
                switch completion {
                case .finished:
                    print("Setting Carry Over successfully changed.")
                    self.getBookInfo()
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.setCarryOver(status: status)
                    })
                    print("Error Settig Carry Over: \(error)")
                    
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func exitBook() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookInfoRequest(bookKey: bookKey)
        let dispatchGroup = DispatchGroup()

        dataManager.exitBook(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Exit Book successfully changed.")
                    AlertManager.shared.update(showAlert: true, message: "가계부에서 나갔습니다.", buttonType: .green)

                    dispatchGroup.enter()
                    let fcmManager = FCMDataManager()
                    fcmManager.fetchTokensFromDatabase(bookKey: self.bookKey, title: "플로니", body: "\(Keychain.getKeychainValue(forKey: .userNickname) ?? "")님이 \(self.bookName)의 가계부를 나갔어요.") {
                        dispatchGroup.leave()
                    }

                    dispatchGroup.enter()
                    self.postNoti(title: "플로니", body: "\(Keychain.getKeychainValue(forKey: .userNickname) ?? "")님이 \(self.bookName)의 가계부를 나갔어요.", imgUrl: "icon_exit") {
                        dispatchGroup.leave()
                    }
                    dispatchGroup.enter()
                    let email = Keychain.getKeychainValue(forKey: .email) ?? ""
                    
                    fcmManager.deleteUserToken(bookKey: self.bookKey, email: email) {
                        print("\(self.bookKey) 가계부 토큰 삭제 성공")
                        print("\(email) 가계부 토큰 삭제 성공")
                        print("유저 토큰 삭제 성공")
                        dispatchGroup.leave()
                    }

                    dispatchGroup.notify(queue: .main) {
                        Keychain.setKeychain("", forKey: .bookKey)
                        //BookExistenceViewModel.shared.bookExistence = false
                        AuthenticationService.shared.newMainTab.toggle()
                        BookExistenceViewModel.shared.getBookExistence()
                    }
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.exitBook()
                    })
                    print("Error Exiting Book : \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }

    func postNoti(title :String, body: String, imgUrl : String,completion: @escaping () -> Void) {
        let currentDate = Date()
        let formatter = ISO8601DateFormatter()
        
        let formattedDate = formatter.string(from: currentDate)
        var viewModel = NotiViewModel()
        
        let db = Firestore.firestore()
        let projectModeRef = db.collection(projectMode).document(projectMode)
        let bookRef = projectModeRef.collection("books").document(self.bookKey)
        let usersCollection = bookRef.collection("users")
        var emails = [String]()
        
        usersCollection.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    emails.append(document.documentID) // 문서의 ID(이메일)을 배열에 추가
                    viewModel.postNoti(title: title, body:body, imgUrl: imgUrl, userEmail: document.documentID, date: formattedDate)
                }
                // 이메일 배열을 여기서 사용합니다.
                print(emails)
                
            }
        }
        completion()
    }
    
    func deleteBook() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookInfoRequest(bookKey: bookKey)
        let dispatchGroup = DispatchGroup()
        dataManager.deleteBook(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("delete Book successfully changed.")
                    AlertManager.shared.update(showAlert: true, message: "가계부가 성공적으로 삭제되었습니다.", buttonType: .green)
                    dispatchGroup.enter()
                    self.fcmManager.deleteBookTokens(bookKey: self.bookKey) {
                        
                        print("\(self.bookKey) 가계부 토큰 삭제 성공")
                        dispatchGroup.leave()
                    }
                    dispatchGroup.enter()
                    let firebaseManager = FirebaseManager()
                    firebaseManager.getPreviousImageRef(in: "\(self.projectMode)/books/\(self.bookKey)") { reference in
                        reference?.delete { error in
                            if let error = error {
                                print("Error deleting previous image: \(error)")
                            } else {
                                print("Previous image successfully deleted")
                            }
                        }
                        dispatchGroup.leave()
                    }
                    dispatchGroup.notify(queue: .main) {
                        Keychain.setKeychain("", forKey: .bookKey)
                        //BookExistenceViewModel.shared.bookExistence = false
                        AuthenticationService.shared.newMainTab.toggle()
                        BookExistenceViewModel.shared.getBookExistence()
                    }
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.deleteBook()
                    })
                    print("Error Exiting Book : \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func resetBook() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookInfoRequest(bookKey: bookKey)
        dataManager.resetBook(parameters: request)
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    print("Reset Book successfully changed.")
                    self.fcmManager.fetchTokensFromDatabase(bookKey: bookKey, title: "플로니", body: "\(bookName) 가계부가 초기화 되었어요.", completion: {})
                    self.postNoti(title: "플로니", body: "\(bookName) 가계부가 초기화 되었어요.", imgUrl: "icon_noti_reset", completion: {})
                    AlertManager.shared.update(showAlert: true, message: "가계부가 초기화 되었습니다.", buttonType: .green)
                    
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.resetBook()
                    })
                    print("Reset Exiting Book : \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    
    func getShareCode() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookInfoRequest(bookKey: bookKey)
        dataManager.getShareCode(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getShareCode()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.bookCode = (dataResponse.value!.code)
                    print("--성공--")
                    print(self.bookCode)
                }
            }.store(in: &cancellableSet)
    }
    func setCurrency(currency : String) {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = SetCurrencyRequest(requestCurrency: currency, bookKey: bookKey)
        dataManager.setCurrency(request)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.setCurrency(currency: currency)
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.currency = dataResponse.value!.myBookCurrency
                    print("--성공--")
                    print("변경된 화폐 단위 : \(self.currency)")
                    let bookName = Keychain.getKeychainValue(forKey: .bookName) ?? ""
                    self.fcmManager.fetchTokensFromDatabase(bookKey: self.bookKey, title: "플로니", body: "\(bookName) 가계부의 화폐가 \(self.currency)로 변경되었어요.", completion: {})
                    self.postNoti(title: "플로니", body: "\(bookName) 가계부의 화폐가 \(self.currency)로 변경되었어요.", imgUrl: "icon_noti_currency", completion: {})
                    DispatchQueue.main.async {
                        CurrencyManager.shared.getCurrency()
                    }
                    AlertManager.shared.update(showAlert: true, message: "화폐 단위가 변경 완료 되었습니다.", buttonType: .green)
                }
            }.store(in: &cancellableSet)
    }
    
    func currencySymbol(currencyUnit : String) -> String {
        var currentCurrency = ""
        switch currencyUnit {
        case "KRW":
            currentCurrency = "원"
            return currentCurrency
        case "USD":
            currentCurrency = "$"
            return currentCurrency
            
        case "EUR":
            currentCurrency = "€"
            return currentCurrency
            
        case "JPY":
            currentCurrency = "¥"
            return currentCurrency
            
        case "CNY":
            currentCurrency = "¥"
            return currentCurrency
            
        case "GBP":
            currentCurrency = "£"
            return currentCurrency
            
        default:
            currentCurrency = "원"
            return currentCurrency
            
        }
    }
    
    func downloadExcelFile() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let currentDate = self.formattedDate(for: selectedExcelDuration)
        let request = DownloadExcelRequest(bookKey: bookKey, excelDuration: selectedExcelDuration.rawValue, currentDate: currentDate)
        let cancellable = dataManager.downloadExcelFile(parameters: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    //x self.createAlert(with: error)
                    print("Error downloading Excel file:", error.localizedDescription)
                    self.createAlert(with: error as! NetworkError, retryRequest: {
                        self.downloadExcelFile()
                    })
                }
            }, receiveValue: { localFileURL in
                print("Excel file saved to:", localFileURL)
                self.excelURL = localFileURL
                self.shareExcelStatus = true
            })
            .store(in: &cancellableSet)
    }
    
    func handleUserSelection(_ selection: String) {
        if let durationType = durationMapping[selection] {
            self.selectedExcelDuration = durationType
        }
    }
    func formattedDate(for type: ExcelDurationType) -> String {
        let calendar = Calendar.current
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        switch type {
        case .thisMonth:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            return dateFormatter.string(from: startOfMonth)

        case .lastMonth:
            var dateComponents = DateComponents()
            dateComponents.month = -1
            let startOfLastMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.date(byAdding: dateComponents, to: now)!))!
            return dateFormatter.string(from: startOfLastMonth)

        case .oneYear:
            var startOfYearComponents = calendar.dateComponents([.year], from: now)
            startOfYearComponents.month = 1
            startOfYearComponents.day = 1
            let startOfYear = calendar.date(from: startOfYearComponents)!
            return dateFormatter.string(from: startOfYear)
            
        case .lastYear:
            var startOfLastYearComponents = calendar.dateComponents([.year], from: now)
            startOfLastYearComponents.year! -= 1  // 년도를 하나 감소
            startOfLastYearComponents.month = 1
            startOfLastYearComponents.day = 1
            let startOfLastYear = calendar.date(from: startOfLastYearComponents)!
            return dateFormatter.string(from: startOfLastYear)

        case .all:
            return dateFormatter.string(from: now)
        }
    }

    //MARK: 방장 필터
    func hostFilter() {
        // role이 "방장"이고, me가 true인 요소를 필터링합니다.
        print("가계부 멤버 : \(bookUsers)")
        let filteredUsers = bookUsers.filter { user in
            user.role == "방장" && user.me == true
        }
        if let host = filteredUsers.first {
            print("방장이며, me가 true인 사용자: \(host)")
            role = "방장"
        } else {
            // 조건에 해당하는 사용자가 없을 경우 처리할 작업을 수행합니다.
            print("해당 조건을 만족하는 사용자가 없습니다.")
            role = "팀원"
        }
    }
    func loadBookPreviewImage() {
        self.bookPreviewImage124 = ProfileManager.shared.bookPreviewImage124
        self.bookPreviewImage36 = ProfileManager.shared.bookPreviewImage36
        self.bookPreviewImage34 = ProfileManager.shared.bookPreviewImage34
    }
    
    func createAlert( with error: NetworkError, retryRequest: @escaping () -> Void) {
        //loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        if let backendError = error.backendError {
            guard let serverError = ServerError(rawValue: backendError.code) else {
                // 서버 에러 코드가 정의되지 않은 경우의 처리
                //showAlert(message: "알 수 없는 서버 에러가 발생했습니다.")
                return
            }
            if error.backendError?.code != "U006" && error.backendError?.code != "B001"{
                AlertManager.shared.handleError(serverError)
            }
            // 에러코드에 따른 추가 로직
            if let errorCode = error.backendError?.code {
                switch errorCode {
                    // 토큰 재발급
                case "U006" :
                    tokenViewModel.tokenReissue {
                        // 토큰 재발급 성공 시, 원래의 요청 재시도
                        retryRequest()
                    }
                    // 아예 틀린 토큰이므로 재로그인해서 다시 발급받아야 함.
                case "U007" :
                    AuthenticationService.shared.logoutDueToTokenExpiration()
                default:
                    break
                }
            }
        } else {
            // BackendError 없이 NetworkError만 발생한 경우
            //showAlert(message: "네트워크 오류가 발생했습니다.")
            
        }
    }
}
