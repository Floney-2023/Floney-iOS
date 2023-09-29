//
//  AddView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI
import Combine
struct AddView: View {
    @StateObject var viewModel = AddViewModel()
    @State var changedStatus = false
    @State var showAlert = false
    @State var title = "잠깐!"
    @State var message = "수정된 내용이 저장되지 않았습니다.\n그대로 나가시겠습니까?"
    
    @State var currency = CurrencyManager.shared.currentCurrency
    
    @Binding var isPresented: Bool
    @State var isShowingBottomSheet = false
    @State var isShowingEditCategory = false
    @State var moneyMaxLength = 11
    @State var maxLength = 12
    @State var isSelectedAssetTypeIndex = 0
    @State var isSelectedCategoryIndex = 0
    @State var root = "" // 자산, 지출, 수입, 이체
    @State var categories: [String] = ["현금", "체크카드", "신용카드", "은행","추가", "추가추가","추가/추가"]
    @State var options = ["지출", "수입", "이체"]
    
    @StateObject var lineModel : LineModel
    @ObservedObject var alertManager = AlertManager.shared

    @State var date : String = "2023-06-20"
    @State var money : String = "" {
        didSet {
            self.changedStatus = true
        }
    }

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    @State var assetType = "자산을 선택하세요" {
        didSet {
            self.changedStatus = true
        }
    }
    @State var category = "분류를 선택하세요" {
        didSet {
            self.changedStatus = true
        }
    }

    @State var content = "" {
        didSet {
            self.changedStatus = true
        }
    }

    @State var toggleOnOff = false {
        didSet {
            self.changedStatus = true
        }
    }

    @State var writer = ""

    var formattedValue: Double? {
            let valueWithoutCommas = money.replacingOccurrences(of: ",", with: "")
            return Double(valueWithoutCommas)
        }
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    var body: some View {
        let nickname = lineModel.mode == "add" ? Keychain.getKeychainValue(forKey: .userNickname) ?? "" : writer
        ZStack {
            VStack {
                HStack {
                    Image("icon_close")
                        .onTapGesture {
                            if changedStatus {
                                self.showAlert = true
                            } else {
                                self.isPresented.toggle()
                            }
                        }
                    Spacer()
                }
                .padding(.leading,20)

                VStack(spacing: 32){
                    //MARK: 금액
                    VStack {
                        HStack {
                            Text("금액")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale6)
                            Spacer()
                        }
   
                        MoneyTextField(text: $money, placeholder: "금액을 입력하세요")
                            .frame(height: UIScreen.main.bounds.height * 0.0487)
                            .onReceive(Just(money)) { value in
                                let trimmedValue = value.filter { "0"..."9" ~= $0 || $0 == "." }
                                let components = trimmedValue.split(separator: ".")
                                
                                // 소수점이 없거나 하나만 있는 경우
                                if components.count <= 1 || (components.count == 2 && components[1].count <= 2) {
                                    if let doubleValue = Double(trimmedValue), doubleValue <= 100_000_000_000 {
                                        money = trimmedValue
                                    } else if let doubleValue = Double(trimmedValue) {
                                        money = String(trimmedValue.dropLast())
                                    }
                                }
                                // 소수점이 둘째 자리 이후로 입력된 경우
                                else if components.count == 2 && components[1].count > 2 {
                                    money = String(components[0]) + "." + components[1].prefix(2)
                                }
                                // 두 개 이상의 소수점이 포함된 경우
                                else {
                                    money = String(components.dropLast().joined(separator: "."))
                                }
                            }
                    } // 금액 VStack
                    
                    //MARK: 지출/수입/이체 선택 토글 버튼
                    HStack(spacing: 0) {
                        ForEach(options.indices, id:\.self) { index in
                            ZStack {
                                Rectangle()
                                    .fill(Color.greyScale10)
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .cornerRadius(8)
                                    .padding(4)
                                    .opacity(lineModel.selectedOptions == index ? 1 : 0.01)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring()) {
                                            lineModel.selectedOptions = index
                                            assetType = "자산을 선택하세요"
                                            category = "분류를 선택하세요"
                                            lineModel.toggleType = options[lineModel.selectedOptions]
                                        }
                                    }
                            }
                            .overlay(
                                Text(options[index])
                                    .font(.pretendardFont(.semiBold, size: 11))
                                    .foregroundColor(lineModel.selectedOptions == index ? .greyScale2: .greyScale8)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .cornerRadius(10)
                    
                    //MARK: 날짜/자산/분류/내용/제외여부
                    VStack(spacing:44) {
                        if !keyboardResponder.isKeyboardVisible {
                            HStack {
                                Text("날짜")
                                    .font(.pretendardFont(.medium, size: 14))
                                    .foregroundColor(.greyScale4)
                                Spacer()
                                Text("\(date)")
                                    .font(.pretendardFont(.medium, size: 14))
                                    .foregroundColor(.greyScale2)
                            }
                            
                            HStack {
                                Text("자산")
                                    .font(.pretendardFont(.medium, size: 14))
                                    .foregroundColor(.greyScale4)
                                Spacer()
                                //MARK: 눌렀을 때 bottom sheet
                                Text("\(assetType)")
                                    .font(.pretendardFont(.medium, size: 14))
                                    .foregroundColor(.greyScale6)
                            }
                            .onTapGesture {
                                self.root = "자산"
                                viewModel.root = self.root
                                viewModel.getCategory()
                                
                                print("\(self.categories)")
                                self.isShowingBottomSheet.toggle()
                            }
                    
                        }
                  
                        
                        HStack {
                            Text("분류")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale4)
                            Spacer()
                            
                            Text("\(category)")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale6)
                        }
                        .onTapGesture {
                            self.root = lineModel.toggleType
                            viewModel.root = self.root
                            viewModel.getCategory()
                            
                            self.isShowingBottomSheet.toggle()
                        }

                        
                        HStack {
                            Text("내용")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale4)
                            
                            ContentTextField(text: $content, placeholder: "내용을 입력하세요")
                                .frame(height: UIScreen.main.bounds.height * 0.018)
                                .onChange(of: content) { newValue in
                                    if newValue.count > maxLength {
                                        content = String(newValue.prefix(maxLength))
                                    }
                                }
                        }

                        
                        if lineModel.selectedOptions != 2 {
                            HStack {
                                Text(lineModel.selectedOptions == 0 ? "예산에서 제외" : "자산에서 제외")
                                    .font(.pretendardFont(.medium, size: 14))
                                    .foregroundColor(.greyScale4)
                                Spacer()
                                Toggle(isOn: $toggleOnOff) {
                                    
                                }.padding(.trailing, 6)
                            }
                         
                        }
                        
                    }.padding(.leading, 10)
                    .padding(.trailing, 6)
                    
                } //VStack
                .padding(20)
                
                Spacer()
                Text("작성자 : \(nickname)")
                    .font(.pretendardFont(.medium, size:12))
                    .foregroundColor(.greyScale8)
                    .padding(.bottom, 32)
                
                if lineModel.mode == "add" {
                    HStack {
                        Button {
                            if viewModel.isVaildAdd(money: money, asset: assetType, category: category) {
                                viewModel.money = money // 금액
                                viewModel.lineDate = date // 날짜
                                viewModel.flow = lineModel.toggleType // 수입, 지출, 이체
                                viewModel.asset = assetType // 자산 타입
                                viewModel.line = category // 분류 타입
                                if content.isEmpty {
                                    viewModel.description = category
                                } else {
                                    viewModel.description = content // 내용
                                }
                                viewModel.except = toggleOnOff // 제외 여부
                                
                                print(viewModel.money)
                                print(viewModel.lineDate)
                                print(viewModel.flow)
                                print(viewModel.asset)
                                print(viewModel.line)
                                print(viewModel.description)
                                print(viewModel.except)
                                
                                viewModel.postLines()
                            }
                            
                        } label: {
                            Text("저장하기")
                                .font(.pretendardFont(.bold, size:14))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .padding(.bottom, 10)
                        .background(Color.primary1)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height:UIScreen.main.bounds.height * 0.085)
                    
                } else if lineModel.mode == "check" {
                    //MARK: 삭제/저장하기 버튼
                    HStack(spacing:0) {
                        Button {
                            viewModel.bookLineKey = lineModel.lineId // PK
                            viewModel.deleteLine()
                        } label: {
                            Text("삭제")
                                .font(.pretendardFont(.bold, size:14))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .padding(.bottom, 10)
                        .background(Color.greyScale2)
                        Button {
                            if viewModel.isVaildAdd(money: money, asset: assetType, category: category) {
                                
                                viewModel.bookLineKey = lineModel.lineId // PK
                                viewModel.money = money // 금액
                                viewModel.lineDate = date // 날짜
                                viewModel.flow = lineModel.toggleType // 수입, 지출, 이체
                                viewModel.asset = assetType // 자산 타입
                                viewModel.line = category // 분류 타입
                                if content.isEmpty {
                                    viewModel.description = category
                                } else {
                                    viewModel.description = content // 내용
                                }
                                viewModel.except = toggleOnOff // 제외 여부
                                
                                print(viewModel.money)
                                print(viewModel.lineDate)
                                print(viewModel.flow)
                                print(viewModel.asset)
                                print(viewModel.line)
                                print(viewModel.description)
                                print(viewModel.except)
                                viewModel.changeLine()
                                
                            }
                            
                        } label: {
                            Text("저장하기")
                                .font(.pretendardFont(.bold, size:14))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .frame(width: UIScreen.main.bounds.width * 2/3)
                        .padding(.bottom, 10)
                        .background(Color.primary1)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height:UIScreen.main.bounds.height * 0.085)
                }  
            } // VStack
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            .onAppear{
                print(lineModel.mode)
                print(date)
                print(money)
                print(assetType)
                print(category)
                print(content)
                print(toggleOnOff)
                print(lineModel.toggleType)
                print(lineModel.selectedOptions)
                print(lineModel.lineId)
            }
            .onChange(of: viewModel.successAdd) { newValue in
                self.isPresented = false
            }
            CustomAlertView(message: AlertManager.shared.message, type: $alertManager.buttontType, isPresented: $alertManager.showAlert)
            CategoryBottomSheet(root: $root, categories: $viewModel.categories, isShowing: $isShowingBottomSheet, isSelectedAssetTypeIndex: $isSelectedAssetTypeIndex, isSelectedAssetType: $assetType, isSelectedCategoryIndex: $isSelectedCategoryIndex, isSelectedCategory: $category, isShowingEditCategory: $isShowingEditCategory)
            
            //MARK: alert
            if showAlert {
                AlertView(isPresented: $showAlert, title: $title, message: $message) {
                    self.isPresented = false
                }
            }

            NavigationLink(destination: CategoryManagementView(isShowingEditCategory: $isShowingEditCategory), isActive: $isShowingEditCategory) {
                EmptyView()
            }
        } // ZStack
    }
    func formatNumber(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: n)) ?? ""
    }
}

class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var isKeyboardVisible: Bool = false

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        isKeyboardVisible = true
    }

    @objc func keyBoardWillHide(notification: Notification) {
        isKeyboardVisible = false
    }
    
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(isPresented: .constant(true), lineModel: LineModel())
            
    }
}

