//
//  CreateBookViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//

import Foundation
import Combine
import FirebaseFirestore

enum createBookType {
    case initial
    case add
}
class CreateBookViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var result : CreateBookResponse = CreateBookResponse(bookKey: "", code: "")
    @Published var bookInfo = BookInfoByCodeResponse(bookName: "", startDay: "", memberCount: 0)
    @Published var bookName = "" {
        didSet {
            if bookName.count > 10 {
                bookName = String(bookName.prefix(10))
            }
        }
    }
    @Published var startDay = ""
    @Published var memberCount : String = ""
    @Published var bookImg : String?
    @Published var createBookLoadingError: String = ""
    @Published var showAlert: Bool = false
    
   // @Published var name : String = ""
    @Published var createBookType : createBookType = .initial
    @Published var profileImg : String?
    @Published var isNextToCreateBook : Bool = false
    @Published var bookCode = ""
    @Published var isNextToEnterBook = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: CreateBookProtocol
    
    init( dataManager: CreateBookProtocol = CreateBook.shared) {
        self.dataManager = dataManager
    }
    func isVaildBookName() -> Bool {
        if bookName.isEmpty {
            AlertManager.shared.handleError(InputValidationError.emptyBookName)
            return false
        }
        return true
    }
    func createBook() {
        let request = CreateBookRequest(name: bookName, profileImg: profileImg)
        print(request)
        dataManager.createBook(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.createBook()
                    })
                    print(dataResponse.error)
                    LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                } else {
                    self.result = dataResponse.value!
                    self.isNextToCreateBook = true
                    print(self.result) // bookkey & code
                    // bookKey는 request할 때 사용, code는 초대할 때 사용
                    print(self.result.code)
                    self.setBookCode()
                    Keychain.setKeychain(self.bookName, forKey: .bookName)
                    LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                }
            }.store(in: &cancellableSet)
    }
    func addBook() {
        let request = CreateBookRequest(name: bookName, profileImg: profileImg)
        print(request)
        dataManager.createBook(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.addBook()
                    })
                    print(dataResponse.error)
                    LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                } else {
                    self.result = dataResponse.value!
                    self.isNextToCreateBook = true
                    print(self.result) // bookkey & code
                    // bookKey는 request할 때 사용, code는 초대할 때 사용
                    print(self.result.code)
                    self.setBookCode()
                    Keychain.setKeychain(self.bookName, forKey: .bookName)
                    LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                }
            }.store(in: &cancellableSet)
    }
    func joinBook() {
        let request = InviteBookRequest(code: bookCode)
        dataManager.bookInfoByCodeBook(bookCode: bookCode)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.bookInfoByCode()
                    })
                    print(dataResponse.error)
                } else {
                    self.bookInfo = dataResponse.value!
                    self.bookName = self.bookInfo.bookName
                    self.dataManager.inviteBook(request)
                        .sink { (dataResponse) in
                            if dataResponse.error != nil {
                                self.createAlert(with: dataResponse.error!, retryRequest: {
                                    self.joinBook()
                                })
                                print(dataResponse.error)
                            } else {
                                self.result = dataResponse.value!
                                print(self.result)
                                print(self.result.code)
                                self.setBookCode()
                                Keychain.setKeychain(self.bookName, forKey: .bookName)
                                let fcmManager = FCMDataManager()
                                fcmManager.fetchTokensFromDatabase(bookKey: self.result.bookKey, title: "플로니", body: "\(Keychain.getKeychainValue(forKey: .userNickname) ?? "")님이 \(self.bookName)의 가계부에 들어왔어요.")
                                self.postNoti(title: "플로니", body: "\(Keychain.getKeychainValue(forKey: .userNickname) ?? "")님이 \(self.bookName)의 가계부에 들어왔어요.", imgUrl: "icon_join")
                                self.isNextToEnterBook = true
                            }
                        }.store(in: &self.cancellableSet)
                }
            }.store(in: &cancellableSet)
        
    }
    func isValidBookCode() -> Bool {
        if bookCode.isEmpty {
            AlertManager.shared.handleError(InputValidationError.bookCodeEmpty)
            return false
        }
        return true
    }
    func inviteBookCode() {
        if let inviteCode = AppLinkManager.shared.inviteCode {
            let request = InviteBookRequest(code: inviteCode)
            dataManager.inviteBook(request)
                .sink { (dataResponse) in
                    if dataResponse.error != nil {
                        self.createAlert(with: dataResponse.error!, retryRequest: {
                            self.inviteBookCode()
                        })
                        print(dataResponse.error)
                    } else {
                        self.result = dataResponse.value!
                        print(self.result) // bookkey & code
                        // bookKey는 request할 때 사용, code는 초대할 때 사용
                        print(self.result.code)
                        self.setBookCode()
                        AppLinkManager.shared.inviteStatus = false
                        AppLinkManager.shared.hasDeepLink = false
                        Keychain.setKeychain(self.bookName, forKey: .bookName)
                        let fcmManager = FCMDataManager()
                        fcmManager.fetchTokensFromDatabase(bookKey: self.result.bookKey, title: "플로니", body: "\(Keychain.getKeychainValue(forKey: .userNickname) ?? "")님이 \(self.bookName)의 가계부에 들어왔어요.")
                        self.postNoti(title: "플로니", body: "\(Keychain.getKeychainValue(forKey: .userNickname) ?? "")님이 \(self.bookName)의 가계부에 들어왔어요.", imgUrl: "icon_join")
                        
                        BookExistenceViewModel.shared.getBookExistence()
                    }
                }.store(in: &cancellableSet)
        }
    }
    func bookInfoByCode() {
        if let inviteCode = AppLinkManager.shared.inviteCode {
            dataManager.bookInfoByCodeBook(bookCode: inviteCode)
                .sink { (dataResponse) in
                    if dataResponse.error != nil {
                        self.createAlert(with: dataResponse.error!, retryRequest: {
                            self.bookInfoByCode()
                        })
                        print(dataResponse.error)
                    } else {
                        self.bookInfo = dataResponse.value!
                        print(self.bookInfo)
                        self.bookName = self.bookInfo.bookName
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS" // 입력 문자열의 형식
                        if let date = inputFormatter.date(from: self.bookInfo.startDay) {
                            let outputFormatter = DateFormatter()
                            outputFormatter.dateFormat = "yyyy.MM.dd" // 원하는 출력 형식
                            let resultString = outputFormatter.string(from: date)
                            self.startDay = resultString
                            print(resultString) // 출력: 2023.07.17
                        } else {
                            print("Invalid date string")
                        }
                        self.memberCount = String(self.bookInfo.memberCount)
                        if let img = self.bookInfo.bookImg {
                            self.bookInfo.bookImg = img
                        }
                    }
                }.store(in: &cancellableSet)
        }
    }
    func setBookCode() {
        Keychain.setKeychain(self.result.bookKey, forKey: .bookKey)
        Keychain.setKeychain(self.result.code, forKey: .bookCode)
    }
    
    func postNoti(title :String, body: String, imgUrl : String) {
        let currentDate = Date()
        let formatter = ISO8601DateFormatter()
        
        let formattedDate = formatter.string(from: currentDate)
        var viewModel = NotiViewModel()

        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(self.result.bookKey)
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
    }
    func createAlert( with error: NetworkError, retryRequest: @escaping () -> Void) {
        //loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        if let backendError = error.backendError {
            guard let serverError = ServerError(rawValue: backendError.code) else {
                // 서버 에러 코드가 정의되지 않은 경우의 처리
                //showAlert(message: "알 수 없는 서버 에러가 발생했습니다.")
                return
            }
            if error.backendError?.code != "U006" {
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
