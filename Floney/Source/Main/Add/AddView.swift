//
//  AddView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI
import Combine
struct AddView: View {
    let scaler = Scaler.shared
    var buttonHandler = ButtonClickHandler()
    @StateObject var viewModel = AddViewModel()
    @StateObject var repeatLineViewModel = ManageRepeatLineViewModel()
    @StateObject var favoriteViewModel = ManageFavoriteLineViewModel()
    @State var changedStatus = false
    @State var showAlert = false
    @State var title = "잠깐!"
    @State var message = "수정된 내용이 저장되지 않았습니다.\n그대로 나가시겠습니까?"
    @State var alertStatus = "modify"
    
    @State var currency = CurrencyManager.shared.currentCurrencyUnit
    
    @Binding var isPresented: Bool
    @State var isShowingBottomSheet = false
    @State var isShowingEditCategory = false
    @State var isShowingFavorite = false
    @State var moneyMaxLength = 11
    @State var maxLength = 20
    @State var isSelectedAssetTypeIndex = 0
    @State var isSelectedCategoryIndex = 0
    @State var root = "" // 자산, 지출, 수입, 이체
    @State var categories: [String] = ["현금", "체크카드", "신용카드", "은행","추가", "추가추가","추가/추가"]
    @State var options = ["지출", "수입", "이체"]
    
    //@ObservedObject var lineModel : LineModel
    @State var mode : String = "add"
    @State var lineId = 0
    @State var toggleType = "지출" // 지출, 수입, 이체
    @State var selectedOptions = 0
    @ObservedObject var alertManager = AlertManager.shared

    @State var date : String = "2023-06-20"
    @State var originalDate: String = ""
    @State var money : String = ""
    let defaultMoney: String = ""
    @State var originalMoney: String = ""
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    @State var assetType = "자산을 선택하세요"
    let defaultAssetType: String = "자산을 선택하세요"
    @State var originalAssetType: String = ""
    @State var category = "분류를 선택하세요"
    let defaultCategory: String = "분류를 선택하세요"
    @State var originalCategory: String = ""

    @State var content = ""
    let defaultContent: String = ""
    @State var originalContent: String = ""

    @State var toggleOnOff = false
    let defaultToggleOnOff: Bool = false
    @State var originalToggleOnOff: Bool = false

    @State var writer = ""
    @State var isShowingCalendarBottomSheet = false
    @State var isShowingRepeatDurationBottomSheet = false
    @State var presentActionSheet = false
    @State var repeatDuration : String?
    @State private var secondsElapsed = 1
    @State private var timer: Timer?
    
    @State var presentFavoriteActionSheet = false

    var formattedValue: Double? {
            let valueWithoutCommas = money.replacingOccurrences(of: ",", with: "")
            return Double(valueWithoutCommas)
        }
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    var body: some View {
        let nickname = mode == "add" ? Keychain.getKeychainValue(forKey: .userNickname) ?? "" : writer
        ZStack {
            VStack(spacing:0) {
                //MARK: Top
                HStack(alignment:.top) {
                    Image("icon_close")
                        .resizable()
                        .frame(width: scaler.scaleWidth(24), height : scaler.scaleWidth(24))
                        .onTapGesture {
                            title = "잠깐!"
                            message = "수정된 내용이 저장되지 않았습니다.\n그대로 나가시겠습니까?"
                            alertStatus = "modify"
                            if mode == "add" {
                                self.checkForChangesWithDefaultAndShowAlert()
                            } else if mode == "check" {
                                self.checkForChangesAndShowAlert()
                            }
                        }
                    Spacer()
                    if mode == "add" {
                        Group {
                            if viewModel.repeatDuration == .none {
                                HStack(spacing:10) {
                                    VStack(spacing:2) {
                                        Image("icon_favorites")
                                            .resizable()
                                            .frame(width: scaler.scaleWidth(24), height : scaler.scaleWidth(24))
                                        Text("")
                                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(12)))
                                            .foregroundColor(.primary1)
                                    }
                                    .onTapGesture {
                                        presentActionSheet = true
                                        presentFavoriteActionSheet = true
                                    }
                                    VStack(spacing:2) {
                                        Image("icon_repeat")
                                            .resizable()
                                            .frame(width: scaler.scaleWidth(24), height : scaler.scaleWidth(24))
                                        Text("")
                                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(12)))
                                            .foregroundColor(.primary1)
                                    }
                                    .onTapGesture {
                                        isShowingRepeatDurationBottomSheet = true
                                    }
                                }
                            } else {
                                HStack(spacing:10) {
                                    VStack(spacing:2) {
                                        Image("icon_favorites")
                                            .resizable()
                                            .frame(width: scaler.scaleWidth(24), height : scaler.scaleWidth(24))
                                        Text("")
                                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(12)))
                                            .foregroundColor(.primary1)
                                    }
                                    .onTapGesture {
                                        presentActionSheet = true
                                        presentFavoriteActionSheet = true
                                    }
                                    VStack(spacing:2) {
                                        Image("icon_repeat_green")
                                            .resizable()
                                            .frame(width: scaler.scaleWidth(24), height : scaler.scaleWidth(24))
                                        Text(viewModel.selectedRepeat)
                                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(12)))
                                            .foregroundColor(.primary1)
                                    }
                                    .onTapGesture {
                                        isShowingRepeatDurationBottomSheet = true
                                    }
                                }
                            }
                        }
                    } else if mode == "check" {
                        if let repeatDuration = self.repeatDuration {
                            if repeatDuration != RepeatDurationType.none.rawValue {
                                Text(viewModel.durationMappingText[repeatDuration]!)
                                    .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale6)
                            }
                        }
                    }
                }
                .frame(height: scaler.scaleHeight(38))
                .padding(.top, scaler.scaleHeight(22))
                .padding(.bottom, scaler.scaleHeight(52))
                .padding(.horizontal, scaler.scaleWidth(20))

                VStack(spacing:scaler.scaleHeight(16)){
                    //MARK: 금액
                    VStack(spacing:scaler.scaleHeight(16)) {
                        HStack {
                            Text("금액")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale6)
                            Spacer()
                        }
   
                        MoneyTextField(text: $money, placeholder: "금액을 입력하세요")
                            .frame(height: scaler.scaleHeight(38))
                            .onReceive(Just(money)) { value in
                                var processedValue = value.filter { "0"..."9" ~= $0 || $0 == "." }
                                
                                if CurrencyManager.shared.hasDecimalPoint {
                                    // Only allow one decimal point and two decimal places
                                    let components = processedValue.split(separator: ".")
                                    if components.count > 2 {
                                        processedValue = String(components[0]) + "." + String(components[1])
                                    } else if components.count == 2 && components[1].count > 2 {
                                        processedValue = String(components[0]) + "." + components[1].prefix(2)
                                    }

                                    // Check for max value
                                    if let doubleValue = Double(processedValue), doubleValue > 999999999.99 {
                                        processedValue = "999999999.99"
                                    }
                                } else {
                                    // Remove any decimal points
                                    processedValue = processedValue.filter { $0 != "." }

                                    // Check for max value
                                    if let intValue = Int(processedValue), intValue > 99999999999 {
                                        processedValue = "99999999999"
                                    }
                                }
                                money = formatNumber(processedValue)
                            }
                    } // 금액 VStack
                    .padding(.bottom, scaler.scaleHeight(16))
                    
                    //MARK: 지출/수입/이체 선택 토글 버튼
                    HStack(spacing: 0) {
                        ForEach(options.indices, id:\.self) { index in
                            ZStack {
                                Rectangle()
                                    .fill(Color.greyScale10)
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .cornerRadius(8)
                                    .padding(scaler.scaleWidth(4))
                                    .opacity(selectedOptions == index ? 1 : 0.01)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring()) {
                                            selectedOptions = index
                                            assetType = "자산을 선택하세요"
                                            isSelectedAssetTypeIndex = 0
                                            category = "분류를 선택하세요"
                                            isSelectedCategoryIndex = 0
                                            toggleType = options[selectedOptions]
                                        }
                                    }
                            }
                            .overlay(
                                Text(options[index])
                                    .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(14)))
                                    .foregroundColor(selectedOptions == index ? .greyScale2: .greyScale8)
                            )
                        }
                    }
                    .disabled(mode == "check" ? true : false)
                    .frame(maxWidth: .infinity)
                    .frame(height:scaler.scaleHeight(38))
                    .cornerRadius(10)

                    //MARK: 날짜/자산/분류/내용/제외여부
                    VStack(spacing:0) {
                        if !keyboardResponder.isKeyboardVisible {
                            HStack {
                                Text("날짜")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale4)
                                Spacer()
                                Text("\(viewModel.selectedDateStr)")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale2)
                            }.frame(height: scaler.scaleHeight(58))
                                .onTapGesture {
                                    self.isShowingCalendarBottomSheet = true
                                }
                            
                            
                            HStack {
                                Text("자산")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale4)
                                Spacer()
                                //MARK: 눌렀을 때 bottom sheet
                                Text("\(assetType)")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(assetType.count > 6 ? .greyScale6 : .greyScale2)
                            }
                            .frame(height: scaler.scaleHeight(58))
                            .onTapGesture {
                                self.root = "자산"
                                viewModel.root = self.root
                                viewModel.getCategory()

                                self.isShowingBottomSheet.toggle()
                            }
                        }
                  
                        
                        HStack {
                            Text("분류")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale4)
                            Spacer()
                            
                            Text("\(category)")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(category.count > 6 ? .greyScale6 : .greyScale2)
                        }
                        .frame(height: scaler.scaleHeight(58))
                        .onTapGesture {
                            // 먼저 키보드를 내립니다
                            UIApplication.shared.endEditing(true)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.root = toggleType
                                viewModel.root = self.root
                                viewModel.getCategory()
                                
                                self.isShowingBottomSheet.toggle()
                            }
                        }

                        
                        HStack {
                            Text("내용")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale4)
                            
                            ContentTextField(text: $content, placeholder: "내용을 입력하세요")
                                .frame(height: scaler.scaleHeight(22))
                                .onChange(of: content) { newValue in
                                    if newValue.count > maxLength {
                                        content = String(newValue.prefix(maxLength))
                                    }
                                }
                        }.frame(height: scaler.scaleHeight(58))

                        
                        if selectedOptions != 2 {
                            HStack {
                                Text(selectedOptions == 0 ? "예산에서 제외" : "자산에서 제외")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale4)
                                Spacer()
                                Toggle(isOn: $toggleOnOff) {
                                    
                                }
                                .toggleStyle(SwitchToggleStyle(tint: Color.primary5))
                                .padding(.trailing, scaler.scaleWidth(6))
                            }
                            .frame(height: scaler.scaleHeight(58))
                         
                        }
                        
                    }.padding(.leading, scaler.scaleWidth(10))
                    .padding(.trailing, scaler.scaleWidth(10))
                    
                } //VStack
                .padding(.horizontal,scaler.scaleWidth(20))
                
                Spacer()
                Text("작성자 : \(nickname)")
                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                    .foregroundColor(.greyScale8)
                    .padding(.bottom, scaler.scaleHeight(36))
                
                if mode == "add" {
                    HStack {
                        Button {
                            if viewModel.isVaildAdd(money: money, asset: assetType, category: category) {
                                viewModel.money = money // 금액
                                viewModel.flow = toggleType // 수입, 지출, 이체
                                viewModel.asset = assetType // 자산 타입
                                viewModel.line = category // 분류 타입
                                if content.isEmpty {
                                    viewModel.description = category
                                } else {
                                    viewModel.description = content // 내용
                                }
                                viewModel.except = toggleOnOff // 제외 여부
                                viewModel.postLines()
                                startTimer()
                            }
                                                        
                        } label: {
                            Text("저장하기")
                                .frame(height:scaler.scaleHeight(66))
                                .frame(maxWidth: .infinity)
                                .font(.pretendardFont(.bold, size:scaler.scaleWidth(14)))
                                .foregroundColor(.white)
                                .padding(.bottom, scaler.scaleHeight(10))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .background(Color.primary1)
                      
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height:scaler.scaleHeight(66))
                    
                } else if mode == "check" {
                    //MARK: 삭제/저장하기 버튼
                    HStack(spacing:0) {
                        Button {
                            if self.repeatDuration == RepeatDurationType.none.rawValue {
                                title = "삭제하기"
                                message = "삭제 하시겠습니까?"
                                alertStatus = "delete"
                                self.showAlert = true 
                            } else {
                                presentActionSheet = true
                                presentFavoriteActionSheet = false
                            }
                        } label: {
                            Text("삭제")
                                .frame(width: scaler.scaleWidth(118))
                                .frame(height:scaler.scaleHeight(66))
                                .font(.pretendardFont(.bold, size:scaler.scaleWidth(14)))
                                .foregroundColor(.white)
                                .padding(.bottom, scaler.scaleHeight(10))
                        }
                        .frame(width: scaler.scaleWidth(118))
                        .frame(maxHeight: .infinity)
                        .background(Color.greyScale2)
                        Button {
                            if viewModel.isVaildAdd(money: money, asset: assetType, category: category) {
                                viewModel.bookLineKey = lineId // PK
                                viewModel.money = money // 금액
                                viewModel.flow = toggleType // 수입, 지출, 이체
                                viewModel.asset = assetType // 자산 타입
                                viewModel.line = category // 분류 타입
                                if content.isEmpty {
                                    viewModel.description = category
                                } else {
                                    viewModel.description = content // 내용
                                }
                                viewModel.except = toggleOnOff // 제외 여부
                                viewModel.changeLine()
                                
                            }
                            
                        } label: {
                            Text("저장하기")
                                .frame(width: scaler.scaleWidth(242))
                                .frame(height:scaler.scaleHeight(66))
                               
                                .font(.pretendardFont(.bold, size:scaler.scaleWidth(14)))
                                .foregroundColor(.white)
                                .padding(.bottom, scaler.scaleHeight(10))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(width: scaler.scaleWidth(242))
                        .background(Color.primary1)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height:scaler.scaleHeight(66))
                }  
            } // VStack
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            .onAppear{
                viewModel.convertStringToDate(date)
                setOriginalValue()
            }
            .onDisappear {
                self.stopTimer()
            }
            .onChange(of: viewModel.successAdd) { newValue in
                self.isPresented = false
            }
            .onChange(of: repeatLineViewModel.successStatus) { newValue in
                self.isPresented = false
            }
            .actionSheet(isPresented: $presentActionSheet) {
                if presentFavoriteActionSheet {
                    ActionSheet(
                        title: Text("즐겨찾기에 추가하시겠습니까?"),
                        message: nil,
                        buttons: [
                            .default(
                                Text("즐겨찾기에 추가"),
                                action: {
                                    if favoriteViewModel.isVaildAdd(money: money, asset: assetType, category: category) {
                                        favoriteViewModel.money = money
                                        favoriteViewModel.lineCategoryName = toggleType
                                        favoriteViewModel.lineSubcategoryName = category
                                        favoriteViewModel.assetSubcategoryName = assetType
                                        if content.isEmpty {
                                            favoriteViewModel.description = category
                                        } else {
                                            favoriteViewModel.description = content // 내용
                                        }
                                        favoriteViewModel.addFavoriteLine()
                                    }
                                }
                            ),
                            .default(
                                Text("즐겨찾기 내역 보기"),
                                action: {
                                    self.isShowingFavorite = true
                                }
                            ),
                            .cancel(
                                Text("취소")
                            )
                        ]
                    )
                } else {
                    ActionSheet(
                        title: Text("이 내역을 삭제하시겠습니까? 반복되는 내역입니다."),
                        message: nil,
                        buttons: [
                            .default(
                                Text("이 내역만 삭제"),
                                action: {
                                    viewModel.bookLineKey = lineId
                                    viewModel.deleteLine()
                                }
                            ),
                            .default(
                                Text("이후 모든 내역 삭제"),
                                action: {
                                    repeatLineViewModel.deleteAllRepeatLine(bookLineKey: lineId)
                                    startTimer()
                                }
                            ),
                            .cancel(
                                Text("취소")
                            )
                        ]
                    )
                }
                

            }
            
            CustomAlertView(message: AlertManager.shared.message, type: $alertManager.buttontType, isPresented: $alertManager.showAlert)
            
            CategoryBottomSheet(root: $root, categories: $viewModel.categories, isShowing: $isShowingBottomSheet, isSelectedAssetTypeIndex: $isSelectedAssetTypeIndex, isSelectedAssetType: $assetType, isSelectedCategoryIndex: $isSelectedCategoryIndex, isSelectedCategory: $category, isShowingEditCategory: $isShowingEditCategory)
            
            AddCalendarBottomSheet(isShowing: $isShowingCalendarBottomSheet, viewModel: viewModel)
            
            RepeatDurationBottomSheet(viewModel: viewModel, selectedDurationIndex: viewModel.selectedDurationIndex, isShowing: $isShowingRepeatDurationBottomSheet)
            //MARK: alert
            if showAlert {
                AlertView(isPresented: $showAlert, title: $title, message: $message) {
                    if alertStatus == "modify" {
                        self.isPresented = false
                    } else {
                        viewModel.bookLineKey = lineId
                        viewModel.deleteLine()
                    }
                }
            }
            
            if mode == "add" && viewModel.repeatDuration != .none && viewModel.isApiCalling {
                LoadingView()
            }
            
            if mode == "check" && repeatLineViewModel.isApiCalling {
                LoadingView()
            }


            NavigationLink(destination: CategoryManagementView(isShowingEditCategory: $isShowingEditCategory), isActive: $isShowingEditCategory) {
                EmptyView()
            }
            
            NavigationLink(destination: ManageFavoriteLineView(isShowing: $isShowingFavorite, root: .addLine), isActive: $isShowingFavorite) {
                EmptyView()
            }
        } // ZStack
    }
    // 숫자를 콤마로 구분하여 형식화하는 함수
    func formatNumber(_ string: String) -> String {
        if string.contains(".") {
            let parts = string.split(separator: ".")
            let integerPart = parts[0]
            
            // .이 문자열의 마지막에 있을 때
            if parts.count == 1 {
                let formattedInteger = formatInteger(String(integerPart))
                return "\(formattedInteger)."
            }
            
            let decimalPart = parts[1]
            let formattedInteger = formatInteger(String(integerPart))
            return "\(formattedInteger).\(decimalPart)"
        } else {
            return formatInteger(string)
        }
    }
    // 정수만 콤마로 구분하여 형식화하는 함수
    func formatInteger(_ string: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: string) {
            return formatter.string(from: number) ?? ""
        }
        return string
    }
    func startTimer() {
        secondsElapsed = 1
        timer?.invalidate() // 기존 타이머가 있다면 중지
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                self.secondsElapsed += 1
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    func checkForChangesAndShowAlert() {
        if date != originalDate ||
            money != originalMoney ||
            content != originalContent ||
            assetType != originalAssetType ||
            category != originalCategory ||
            toggleOnOff != originalToggleOnOff {
            // 변경된 값이 있으면 알러트 표시
            self.showAlert = true
        } else {
            self.isPresented.toggle()
        }
    }
    func checkForChangesWithDefaultAndShowAlert() {
        if date != originalDate ||
            money != defaultMoney ||
            content != defaultContent ||
            assetType != defaultAssetType ||
            category != defaultCategory ||
            toggleOnOff != defaultToggleOnOff {
            // 변경된 값이 있으면 알러트 표시
            self.showAlert = true
        } else {
            self.isPresented.toggle()
        }
    }
        
    func setOriginalValue() {
        self.originalDate = self.date
        self.originalMoney = self.money
        self.originalContent = self.content
        self.originalAssetType = self.assetType
        self.originalCategory = self.category
        self.originalToggleOnOff = self.toggleOnOff
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
        AddView(isPresented: .constant(true))
            
    }
}

