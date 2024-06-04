//
//  AddFavoriteLineView.swift
//  Floney
//
//  Created by 남경민 on 5/22/24.
//

import SwiftUI
import Combine
struct AddFavoriteLineView: View {
    let scaler = Scaler.shared

    @StateObject var viewModel = ManageFavoriteLineViewModel()
    @StateObject var categoryViewModel = AddViewModel()
    @State var changedStatus = false
    @State var showAlert = false
    @State var title = "잠깐!"
    @State var message = "수정된 내용이 저장되지 않았습니다.\n그대로 나가시겠습니까?"
    @State var alertStatus = "modify"
    @State var currency = CurrencyManager.shared.currentCurrencyUnit
    
    @Binding var isPresented: Bool
    @State var isShowingBottomSheet = false
    @State var isShowingEditCategory = false
    @State var moneyMaxLength = 11
    @State var maxLength = 20
    @State var isSelectedAssetTypeIndex = 0
    @State var isSelectedCategoryIndex = 0
    @State var root = "" // 자산, 지출, 수입, 이체
    @State var categories: [String] = ["현금", "체크카드", "신용카드", "은행","추가", "추가추가","추가/추가"]
    @State var options = ["지출", "수입", "이체"]
    
    @State var lineId = 0
    @State var toggleType = "지출" // 지출, 수입, 이체
    @State var selectedOptions = 0
    @ObservedObject var alertManager = AlertManager.shared

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

    @State var presentActionSheet = false

    @ObservedObject private var keyboardResponder = KeyboardResponder()
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                //MARK: Top
                HStack(alignment:.center) {
                    Text("즐겨찾기 추가")
                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                        .foregroundColor(.greyScale1)
                        .padding(.leading, scaler.scaleWidth(117))
                    Spacer()
                    Image("icon_close")
                        .resizable()
                        .frame(width: scaler.scaleWidth(24), height : scaler.scaleWidth(24))
                        .onTapGesture {
                            title = "잠깐!"
                            message = "수정된 내용이 저장되지 않았습니다.\n그대로 나가시겠습니까?"
                            alertStatus = "modify"
                            self.checkForChangesWithDefaultAndShowAlert()
                        }

                }
                .frame(height: scaler.scaleHeight(38))
                .padding(.top, scaler.scaleHeight(18))
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
                    .frame(maxWidth: .infinity)
                    .frame(height:scaler.scaleHeight(38))
                    .cornerRadius(10)

                    //MARK: 날짜/자산/분류/내용/제외여부
                    VStack(spacing:0) {
                        if !keyboardResponder.isKeyboardVisible {
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
                                categoryViewModel.root = self.root
                                categoryViewModel.getCategory()

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
                                categoryViewModel.root = self.root
                                categoryViewModel.getCategory()
                                
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
                HStack {
                    Button {
                        if viewModel.isVaildAdd(money: money, asset: assetType, category: category) {
                            viewModel.money = money // 금액
                            viewModel.lineCategoryName = toggleType // 수입, 지출, 이체
                            viewModel.assetSubcategoryName = assetType // 자산 타입
                            viewModel.lineSubcategoryName = category // 분류 타입
                            viewModel.exceptStatus = toggleOnOff // 제외 여부
                            if content.isEmpty {
                                viewModel.description = category
                            } else {
                                viewModel.description = content // 내용
                            }
                            viewModel.addFavoriteLine()
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
                    .background(Color.greyScale2)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height:scaler.scaleHeight(66))
            } // VStack
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            .onChange(of: viewModel.successAdd) { newValue in
                self.isPresented = false
            }
            CustomAlertView(message: AlertManager.shared.message, type: $alertManager.buttontType, isPresented: $alertManager.showAlert)
            
            CategoryBottomSheet(root: $root, categories: $categoryViewModel.categories, isShowing: $isShowingBottomSheet, isSelectedAssetTypeIndex: $isSelectedAssetTypeIndex, isSelectedAssetType: $assetType, isSelectedCategoryIndex: $isSelectedCategoryIndex, isSelectedCategory: $category, isShowingEditCategory: $isShowingEditCategory, showEditText: false)
            
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

    func checkForChangesWithDefaultAndShowAlert() {
        if money != defaultMoney ||
            content != defaultContent ||
            assetType != defaultAssetType ||
            category != defaultCategory ||
            toggleOnOff != defaultToggleOnOff {
            self.showAlert = true
        } else {
            self.isPresented.toggle()
        }
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
        
}



#Preview {
    AddFavoriteLineView(isPresented: .constant(true))
}
