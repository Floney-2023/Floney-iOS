//
//  BottomSheet.swift
//  Floney
//
//  Created by 남경민 on 2023/04/13.
//


import SwiftUI
import Kingfisher
//import UIKit

//enum BottomSheetType: Int {
   // case accountBook = 0
    //case shareBook = 1
    
   // func view() -> AnyView {
        //switch self {
        //case .accountBook:
           // return AnyView(AccountBookBottomSheet(showingTabbar: <#Binding<Bool>#>))
            /*
             case .shareBook:
             return AnyView(ShareBookBottomSheet())*/
            
       // }
   // }
//}

struct BottomSheet: View {
    
    @Binding var isShowing: Bool
    
    var content: AnyView
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .padding(.bottom, 44)
                    .transition(.move(edge: .bottom))
                    .background(
                        Color(.white)
                    )
                    .cornerRadius(12, corners: [.topLeft, .topRight])
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

//MARK: 가계부 생성, 코드 입력, 추가하기 bottom sheet
struct AccountBookBottomSheet: View{
    let buttonHeight: CGFloat = 46
    @Binding var isShowing: Bool
    @Binding var showingTabbar : Bool
    @Binding var isNextToCreateBook : Bool
    @Binding var isNextToEnterCode : Bool
    @State var tag:Int? = nil
    @State var isSelected = 0
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingTabbar = true
                        isShowing.toggle()
                    }
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        Text("가계부 추가")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size: 18))
                        Spacer()
                    }
                    .padding(.top, 24)
                    
                    VStack(spacing : 18) {
                        Button {
                            isSelected = 0
                        } label: {
                            HStack {
                                ZStack {
                                    Text("가계부 생성하기")
                                        .frame(alignment: .center)
                                        .foregroundColor(isSelected == 0 ? .greyScale1 : .greyScale8)
                                        .font(.pretendardFont(.regular, size: 14))
                                        .lineLimit(1)
                                    HStack {
                                        Spacer()
                                        Image(isSelected == 0 ? "icon_check_circle_activated" : "icon_check_circle_disabled")
                                            .padding(.trailing, 20)
                                    }
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isSelected == 0 ? Color.primary2 : Color.greyScale8, lineWidth: 1)
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .frame(height: buttonHeight)
                        
                        Button {
                            isSelected = 1
                        } label: {
                            HStack {
                                ZStack {
                                    Text("코드 입력하기")
                                        .foregroundColor(isSelected == 1 ? .greyScale1 : .greyScale8)
                                        .font(.pretendardFont(.regular, size: 14))
                                        .lineLimit(1)
                                    HStack {
                                        Spacer()
                                        Image(isSelected == 1 ? "icon_check_circle_activated" : "icon_check_circle_disabled")
                                            .padding(.trailing, 20)
                                    }
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isSelected == 1 ? Color.primary2 : Color.greyScale8, lineWidth: 1)
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .frame(height: buttonHeight)
                        
                        
                        ButtonLarge(label: "추가하기", background: .primary1, textColor: .white,  strokeColor: .primary1, fontWeight: .bold, action: {
                          
                            if isSelected == 0 {
                                self.isNextToCreateBook = true
                            } else {
                                //코드 입력하기
                                self.isNextToEnterCode = true
                            }
                            isShowing = false
                        })
                        .frame(height: buttonHeight)
                        
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
                .transition(.move(edge: .bottom))
                .background(
                    Color(.white)
                )
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .onAppear {
                    showingTabbar = false
                }
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

//MARK: 친구 초대하기 bottom sheet
struct ShareBookBottomSheet: View{
    var appLinkManager = AppLinkManager()
    let buttonHeight: CGFloat = 46
    @ObservedObject var viewModel : SettingBookViewModel
    @Binding var isShowing : Bool
    //@Binding var bookCode : String
    @Binding var onShareSheet : Bool
    //@Binding var shareUrl : String?
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                VStack(spacing: 24) {
                    HStack {
                        Text("친구들을 초대해서\n함께 가계부를 적어보세요🍀")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size: 18))
                        Spacer()
                    }
                    .padding(.top, 24)
                    
                    VStack(spacing : 28) {
                        VStack(spacing:6) {
                            HStack {
                                Text("초대 코드")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale8)
                                Spacer()
                            }
                            ButtonLarge(label: viewModel.bookCode, background: .greyScale12, textColor: .greyScale2, strokeColor: .greyScale12, action: {
                                
                            })
                            .frame(height: buttonHeight)
                            
                        }
                        ButtonLarge(label: "공유하기",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                            DispatchQueue.main.async {
                                let url = appLinkManager.generateDeepLink(inviteCode: viewModel.bookCode)
                                print("share url : \(url)")
                                print("공유하기")
                                viewModel.shareUrl = url
                                print("share url : \(viewModel.shareUrl)")
                                onShareSheet = true
                                isShowing = false
                            }
                            
                        })
                        .frame(height: buttonHeight)
                        .onTapGesture {
                            
                        }
                        
                    }
                    VStack {
                        Text("나중에 하기")
                            .font(.pretendardFont(.regular, size: 12))
                            .foregroundColor(.greyScale6)
                        Divider()
                            .frame(width: 70,height: 1.0)
                            .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.greyScale6)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
                .transition(.move(edge: .bottom))
                .background(
                    Color(.white)
                )
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .onAppear {
                    viewModel.getShareCode()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        
    }
}

//MARK: 예산 설정 bottom sheet
struct SetBudgetBottomSheet: View {
    @State private var keyboardHeight: CGFloat = 0
    let buttonHeight: CGFloat = 46
    @State var label = "예산을 입력하세요."
    @Binding var isShowing: Bool
    @ObservedObject var viewModel : SettingBookViewModel
    @State var budget : String = ""
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                VStack(spacing: 24) {
                    
                    HStack {
                        Text("예산 설정")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size: 18))
                        Spacer()
                    }
                    .padding(.top, 24)
                    
                    VStack(spacing : 28) {
                        /*
                         ButtonLarge(label: "예산을 입력하세요", background: .greyScale12, textColor: .greyScale2, strokeColor: .greyScale12, action: {
                         
                         })
                         .frame(height: buttonHeight)
                         */
                        TextFieldLarge(label: $label, content: $budget)
                            .frame(height: buttonHeight)
                        
                        ButtonLarge(label: "저장하기",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                            if let floatValue = Float(budget) {
                                // 변환 성공
                                print(floatValue) // 출력: 3200.4
                                viewModel.budget = floatValue
                                viewModel.setBudget()
                            } else {
                                // 변환 실패
                                print("변환 실패")
                            }
                        })
                        .frame(height: buttonHeight)
                        
                    }
                    VStack {
                        Text("초기화하기")
                            .font(.pretendardFont(.regular, size: 12))
                            .foregroundColor(.greyScale6)
                        Divider()
                            .frame(width: 70,height: 1.0)
                            .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.greyScale6)
                    }
                    .onTapGesture {
                        print(viewModel.budget) // 출력: 3200.4
                        viewModel.budget = 0
                        viewModel.setBudget()
                    }
                }
                .padding(.horizontal, 20)
                
                .padding(.bottom, 44)
                .transition(.move(edge: .bottom))
                .background(
                    Color(.white)
                )
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .offset(y: -keyboardHeight)  // 여기에 오프셋 추가
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                self.keyboardHeight = height
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
}

//MARK: 초기 자산 설정 bottom sheet
struct SetInitialAssetBottomSheet: View {
    @State private var keyboardHeight: CGFloat = 0
    let buttonHeight: CGFloat = 46
    @State var label = "초기 자산을 입력하세요."
    @Binding var isShowing: Bool
    @ObservedObject var viewModel : SettingBookViewModel
    @State var initialAsset : String = ""
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                VStack(spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("초기 자산 설정")
                                .foregroundColor(.greyScale1)
                                .font(.pretendardFont(.bold,size: 18))
                            
                            Text("현재 모아놓은 자산을 입력해 주세요.\n플로니가 앞으로의 자산 흐름을 보여드릴게요.")
                                .foregroundColor(.greyScale6)
                                .font(.pretendardFont(.medium,size: 13))
                            
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 24)
                    
                    VStack(spacing : 28) {
                        
                        TextFieldLarge(label: $label, content: $initialAsset)
                            .frame(height: buttonHeight)
                        
                        ButtonLarge(label: "저장하기",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                            if let floatValue = Float(initialAsset) {
                                // 변환 성공
                                print(floatValue) // 출력: 3200.4
                                viewModel.asset = floatValue
                                viewModel.setAsset()
                            } else {
                                // 변환 실패
                                print("변환 실패")
                            }
                        })
                        .frame(height: buttonHeight)
                        
                    }
                    VStack {
                        Text("초기화하기")
                            .font(.pretendardFont(.regular, size: 12))
                            .foregroundColor(.greyScale6)
                        Divider()
                            .frame(width: 70,height: 1.0)
                            .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                            .foregroundColor(.greyScale6)
                    }
                    .onTapGesture {
                        print(viewModel.asset) // 출력: 3200.4
                        viewModel.asset = 0
                        viewModel.setAsset()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
                .transition(.move(edge: .bottom))
                .background(
                    Color(.white)
                )
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .offset(y: -keyboardHeight)  // 여기에 오프셋 추가
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                self.keyboardHeight = height
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
}

//MARK: 이월 설정 bottom sheet
struct CarriedOverBottomSheet: View {
    let buttonHeight: CGFloat = 46
    @Binding var isShowing: Bool
    @ObservedObject var viewModel :SettingBookViewModel
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                
                //MARK: Background
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                //MARK: content
                VStack(spacing: 24) {
                    HStack {
                        Text("이월 설정")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size: 18))
                        Spacer()
                    }
                    .padding(.top, 24)
                    
                    HStack {
                        Text("지날달 총수입")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .font(.pretendardFont(.medium, size: 11))
                            .foregroundColor(.greyScale2)
                            .background(Color.background2)
                            .cornerRadius(10)
                        Image("-")
                        Text("지날달 총지출")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .font(.pretendardFont(.medium, size: 11))
                            .foregroundColor(.greyScale2)
                            .background(Color.background2)
                            .cornerRadius(10)
                        Image("=")
                        Text("다음달 시작금액")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .font(.pretendardFont(.medium, size: 11))
                            .foregroundColor(.white)
                            .background(Color.primary5)
                            .cornerRadius(10)
                    }
                    HStack{
                        Text("이월 설정은 지난 달에 기록된 수입에서 지출을 차감한 금액을\n다음 달로 넘기는 기능입니다.")
                            .font(.pretendardFont(.regular, size: 12))
                            .foregroundColor(.greyScale2)
                        Spacer()
                    }
                    HStack {
                        Text("남은 금액이 마이너스 인 경우 지출로 기록되며\n플러스인 경우는 수입으로 기록됩니다.")
                            .font(.pretendardFont(.regular, size: 12))
                            .foregroundColor(.greyScale2)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    HStack {
                        Button {
                            //self.onOff = false
                            viewModel.setCarryOver(status: false)
                        } label: {
                            Text("OFF")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(viewModel.carryOver ? .greyScale8 : .primary2)
                                .frame(alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.carryOver ? Color.greyScale8 : Color.primary2, lineWidth: 1) // Set the border
                        )
                        .frame(height: buttonHeight)
                        
                        Button {
                            //self.onOff = true
                            viewModel.setCarryOver(status: true)
                        } label: {
                            Text("ON")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(viewModel.carryOver ? .primary2 : .greyScale8)
                                .frame(alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.carryOver ? Color.primary2 : Color.greyScale8, lineWidth: 1) // Set the border
                        )
                        .frame(height: buttonHeight)
                        
                    }.frame(maxWidth: .infinity)
                    
                } //VStack
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
                .padding(.top, 12)
                .transition(.move(edge: .bottom))
                .background(
                    Color(.white)
                )
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .onChange(of: viewModel.carryOver) { newValue in
                    isShowing = false
                }
            } // if
        } //ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}


struct CategoryBottomSheet: View {
    let buttonHeight: CGFloat = 38
    @Binding var root : String
    @Binding var categories : [String]
    @Binding var isShowing: Bool
    @Binding var isSelectedAssetTypeIndex : Int
    @Binding var isSelectedAssetType : String
    @Binding var isSelectedCategoryIndex : Int
    @Binding var isSelectedCategory : String
    @Binding var isShowingEditCategory : Bool
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                //MARK: Background
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                //MARK: content
                VStack(spacing: 12) {
                    HStack {
                        Text(root == "자산" ? "자산" : "분류")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size: 18))
                        Spacer()
                        
                        Button  {
                    
                                print("category 편집 토글")
                                isShowingEditCategory = true
                            
                                
                        } label: {
                            Text("편집")
                                .foregroundColor(.greyScale4)
                                .font(.pretendardFont(.regular,size: 14))
                                
                        }

                    }
                    .padding(.top, 24)
                    
                    CategoryFlowLayout(root: $root,
                                       categories: $categories,
                                       isSelectedAssetTypeIndex: $isSelectedAssetTypeIndex,
                                       isSelectedAssetType: $isSelectedAssetType,
                                       isSelectedCategoryIndex: $isSelectedCategoryIndex,
                                       isSelectedCategory: $isSelectedCategory,
                                       isShowing: $isShowing)
                    
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
                .padding(.top, 12)
                .transition(.move(edge: .bottom))
                .background(
                    Color(.white)
                )
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .frame(height: UIScreen.main.bounds.height / 2) // Screen height is divided by 2
                
                
            } // if
            
            
        } //ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}




struct CategoryFlowLayout: View {
    @Binding var root : String
    @State private var totalWidth = CGFloat.zero
    @Binding var categories: [String]
    @Binding var isSelectedAssetTypeIndex : Int
    @Binding var isSelectedAssetType : String
    @Binding var isSelectedCategoryIndex : Int
    @Binding var isSelectedCategory : String
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
    }
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        let verticalSpacing: CGFloat = 12
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.categories.indices, id: \.self) { index in
                CategoryButton(
                    label: self.categories[index],
                    isSelected: root == "자산" ? self.isSelectedAssetTypeIndex == index : self.isSelectedCategoryIndex == index,
                    action: {
                        if root == "자산" {
                            self.isSelectedAssetTypeIndex = index
                            isSelectedAssetType = categories[index]
                        } else {
                            self.isSelectedCategoryIndex = index
                            isSelectedCategory = categories[index]
                        }
                        isShowing.toggle()
                    }
                )
                .padding([.horizontal], 4)
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height + verticalSpacing
                    }
                    let result = width
                    if index < self.categories.count - 1 {
                        width -= d.width
                    } else {
                        width = 0
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: { _ in
                    let result = height
                    if width == 0 {
                        //if the item is the last in the row
                        height = 0
                    }
                    return result
                })
            }
        }
    }
}

struct DayLinesBottomSheet: View {
    let buttonHeight: CGFloat = 38
    @StateObject var viewModel : CalendarViewModel
    @Binding var isShowing: Bool
    @Binding var isShowingAddView : Bool
    //var encryptionManager = CryptManager()
    
    var body: some View{
        let year = String(describing: viewModel.selectedYear)
        ZStack(alignment: .bottom) {
            if (isShowing) {
                //MARK: Background
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                //MARK: content
                
                VStack() {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(year)년")
                                .font(.pretendardFont(.semiBold, size: 14))
                                .foregroundColor(.greyScale6)
                            Text("\(viewModel.selectedMonth)월 \(viewModel.selectedDay)일")
                                .font(.pretendardFont(.semiBold, size: 16))
                                .foregroundColor(.greyScale1)
                            
                        }
                        Spacer()
                        VStack {
                            // Spacer()
                            Text("내역 추가")
                                .font(.pretendardFont(.semiBold, size: 12))
                                .foregroundColor(.primary2)
                                .onTapGesture {
                                    isShowing.toggle()
                                    self.isShowingAddView.toggle()
                                }
                            //Spacer()
                        }
                    }
                    .padding(.top, 24)
                    
                    VStack {
                    ScrollView(showsIndicators: false) {
                       
                            if Calendar.current.component(.day, from: viewModel.selectedDate) == 1 {
                                
                                if viewModel.dayLineCarryOver.carryOverStatus {
                                    HStack {
                                        if viewModel.seeProfileImg {
                                            Image("book_profile_32")
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        }
                                        VStack(alignment: .leading, spacing: 3){
                                            Text("이월")
                                                .font(.pretendardFont(.semiBold, size: 14))
                                                .foregroundColor(.greyScale2)
                                            Text("-")
                                                .font(.pretendardFont(.medium, size: 12))
                                                .foregroundColor(.greyScale6)
                                        }
                                        Spacer()
                                        Text("\(Int(viewModel.dayLineCarryOver.carryOverMoney))")
                                            .font(.pretendardFont(.semiBold, size: 16))
                                            .foregroundColor(.greyScale2)
                                    }
                                    
                                }
                            }
                            if viewModel.dayLines.count == 0 {
                                Image("no_line")
                                Text("내역이 없습니다.")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale6)
                            } else {
                                ForEach(viewModel.dayLines.indices, id: \.self) { index in
                                    HStack {
                                        if viewModel.seeProfileImg {
                                            if let userImg = viewModel.userImages {
                                                if let img = userImg[index] {
                                                    if img == "user_default" {
                                                        Image("user_profile_32")
                                                            .clipShape(Circle())
                                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                                        
                                                    } else if img.hasPrefix("random"){
                                                        let components = img.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                                        let random = components.first!  // "random"
                                                        let number = components.last!   // "5"
                                                        Image("img_user_random_profile_0\(number)_32")
                                                            .clipShape(Circle())
                                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                                    }
                                                    else  {
                                                        //let url = encryptionManager.decrypt(img, using: encryptionManager.key!)
                                                        let url = URL(string : img)
                                                        KFImage(url)
                                                            .placeholder { //플레이스 홀더 설정
                                                                Image("user_profile_32")
                                                            }.retry(maxCount: 3, interval: .seconds(5)) //재시도
                                                            .onSuccess { success in //성공
                                                                print("succes: \(success)")
                                                            }
                                                            .onFailure { error in //실패
                                                                print("failure: \(error)")
                                                            }
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                                            .frame(width: 32, height: 32) //resize
                                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                                     
                                                        /*
                                                        URLImage(url: URL(string: url!)!)
                                                            .aspectRatio(contentMode: .fill)
                                                            .clipShape(Circle())
                                                            .frame(width: 34, height: 34)
                                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))*/
                                                        
                                                    }
                                                } else { //null
                                                    Image("book_profile_32")
                                                        .clipShape(Circle())
                                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                                }
                                            } else {
                                                Image("user_profile_32")
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                                    
                                            }
                                        }
                                        if let line = viewModel.dayLines[index] {
                                            VStack(alignment: .leading, spacing: 3) {
                                                Text("\(line.content)")
                                                    .font(.pretendardFont(.semiBold, size: 14))
                                                    .foregroundColor(.greyScale2)
                                                HStack {
                                                    ForEach(line.category, id: \.self) { category in
                                                        Text("\(category)‧")
                                                            .font(.pretendardFont(.medium, size: 12))
                                                            .foregroundColor(.greyScale6)
                                                    }
                                                    
                                                }
                                            }
                                            
                                            Spacer()
                                            if line.assetType == "INCOME" {
                                                Text("+\(line.money)")
                                                    .font(.pretendardFont(.semiBold, size: 16))
                                                    .foregroundColor(.greyScale2)
                                            } else if line.assetType == "OUTCOME" {
                                                Text("-\(line.money)")
                                                    .font(.pretendardFont(.semiBold, size: 16))
                                                    .foregroundColor(.greyScale2)
                                                
                                            }
                                        }
                                    }
                                } //ForEach
                            }
  
                        } // Scroll View
                        
                    } //VStack
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //.frame(height: 200)
                    .onAppear {
                        viewModel.dayLinesDate = viewModel.selectedDateStr
                        viewModel.getDayLines()
                    }
                    
                } // VStack
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
                .padding(.top, 0)
                .transition(.move(edge: .bottom))
                .background(
                    Color(.white)
                )
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .frame(height: UIScreen.main.bounds.height / 2) // Screen height is divided by 2
                
            } // if
        } //ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        
    }
}

//MARK: 임시 비밀번호 완료 bottom sheet
struct PasswordBottomSheet: View{
    let buttonHeight: CGFloat = 46
    @Binding var isShowing : Bool
    @Binding var isShowingLogin : Bool
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                VStack(spacing: 24) {
                    HStack {
                        Text("임시 비밀번호가\n발송되었습니다.")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size: 18))
                        Spacer()
                    }
                    .padding(.top, 24)
                    
                    VStack(spacing : 28) {
                            HStack {
                                Text("임시 비밀번호로 로그인 후\n새로운 비밀번호로 변경해 주세요.")
                                    .font(.pretendardFont(.medium, size: 13))
                                    .foregroundColor(.greyScale6)
                                Spacer()
                            }
                        ButtonLarge(label: "다시 로그인하기",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                            //let url = firebaseManager.createDynamicLink(for: "A9BC7ACE")!
                            print("다시 로그인 하기")
                            //shareUrl = url
                            isShowing = false
                            isShowingLogin = true
                        })
                        .frame(height: buttonHeight)
                        
                        
                    }
                   
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 44)
                .transition(.move(edge: .bottom))
                .background(
                    Color(.white)
                )
                .cornerRadius(12, corners: [.topLeft, .topRight])
                
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        
    }
}

//MARK: 캘린더 bottom sheet
struct CalendarBottomSheet: View {
    let buttonHeight: CGFloat = 46
    @Binding var isShowing : Bool
    @Binding var showingTab :Bool
    @ObservedObject var viewModel : CalculateViewModel
    @State var pickerPresented = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }

                MonthView(viewModel: viewModel, isShowing: $isShowing, pickerPresented: $pickerPresented)
                    
            }
            
        } //
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        
        PickerBottomSheet(showingTab: $showingTab, isShowing: $pickerPresented, yearMonth: $viewModel.yearMonth)
    }


}

struct MonthView: View {
    @ObservedObject var viewModel : CalculateViewModel
    @Binding var isShowing : Bool
    @Binding var pickerPresented : Bool

    private var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }
    
    private var yearAndMonthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM"
        return formatter
    }

    var body: some View {
        @State var weeks = viewModel.daysList
            VStack {
                HStack {
                    Image("icon_left")
                        .onTapGesture {
                            // 한달 전으로 이동
                            viewModel.selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.selectedDate) ?? viewModel.selectedDate
                        }
                    
                    Spacer()
                    
                    Button(action: {
                        // 피커 뷰 표시
                        self.pickerPresented = true
                        
                    }) {
                        Text("\(yearAndMonthFormatter.string(from:viewModel.selectedDate))")
                            .font(.pretendardFont(.semiBold, size: 22))
                            .foregroundColor(.greyScale2)
                    }
                    
                    Spacer()
                    
                    Image("icon_right")
                        .onTapGesture {
                            // 한달 후로 이동
                            viewModel.selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.selectedDate) ?? viewModel.selectedDate
                        }
                }
                
                //MARK: 요일
                HStack {
                    ForEach(viewModel.daysOfTheWeek, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(.pretendardFont(.regular, size: 14))
                            .foregroundColor(.greyScale6)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 15)

                //MARK: 날짜
                ForEach(weeks.indices, id: \.self) { i in
                    Week(viewModel: viewModel, days: $weeks[i], selectedDates: $viewModel.selectedDates)
                }
                Spacer()
                //MARK: 선택하기 버튼
                Button {
                    if let startDate = viewModel.selectedDates.first, let endDate = viewModel.selectedDates.last {
                        viewModel.startDateStr = dateFormatter.string(from: startDate)
                        viewModel.endDateStr = dateFormatter.string(from: endDate)
                        viewModel.extractSelectedDatesStr()
                        print("시작 날짜 \(viewModel.startDateStr)")
                        print("끝나는 날짜 \(viewModel.endDateStr)")
                    }
                    isShowing = false
                } label: {
                    Text("선택")
                        .padding()
                        .withNextButtonFormmating(.primary1)
                }
            }
            .frame(height: 490)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.bottom, 44)
            .padding(.top, 24)
            .transition(.move(edge: .bottom))
            .background(
                Color(.white)
            )
            .cornerRadius(12, corners: [.topLeft, .topRight])
            .onChange(of: viewModel.daysList) { newValue in
                weeks = newValue
            }
    }
   
}

//MARK: 일주일씩 그리기
struct Week: View {
    @ObservedObject var viewModel : CalculateViewModel
    @Binding var days : [Date]
    @Binding var selectedDates : [Date]
    
    let colWidth = UIScreen.main.bounds.width / 7

    var body: some View {
        @State var checkPeriod = validPeriod()
        let weekFirst = days.first!
        let weekLast = days.last!
        let lastDayOfWeekFirst = getLastDayOfMonth(date: weekFirst)
        
        ZStack {
            if selectedDates.count == 2 {
                    if checkPeriod {
                    VStack(spacing: 0) {
                        
                        HStack(spacing: 0) {
                            let firstStartDay = weekFirst.day
                            let firstEndDay = (weekFirst.month == selectedDates.first!.month) ? selectedDates.first!.day : (lastDayOfWeekFirst + selectedDates.first!.day)
                            
                            let firstSpacerWidth = colWidth * CGFloat(firstEndDay - firstStartDay)
                            
                            if (weekFirst <= selectedDates.first! && selectedDates.first! <= weekLast ) {
                                Spacer()
                                    .frame(width: firstSpacerWidth, height: 20)
                            }
                            

                            Text("")
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale2)
                                .padding(.vertical, 2)
                                .frame(maxWidth: .infinity)
                                .frame(height: 32)
                                .background(Color.greyScale12)

                            
                            let lastDayOfSelectedDates = getLastDayOfMonth(date: selectedDates.last!)
                            let lastStartDay = selectedDates.last!.day
                            let lastEndDay = (weekLast.month == selectedDates.last!.month) ? weekLast.day : (lastDayOfSelectedDates + weekLast.day)

                                let lastSpacerWidth = colWidth * CGFloat(lastEndDay - lastStartDay)
                                if (weekFirst <= selectedDates.last! && selectedDates.last! <= weekLast ) {
                                    Spacer()
                                        .frame(width: lastSpacerWidth, height: 20)
                                }
                        }
                        //ForEach
                    } //VStack
                    .onAppear {
                        print("in week view days : \(days)")
                    }
                } //if
            }
 
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { value in
                    VStack(spacing: 0) {
                            if value.day > 0 {
                                Text("\(value.day)")
                                   // .padding(10)
                                    .font(.pretendardFont(.regular,size: 14))
                                    .foregroundColor(selectedDates.contains(value) ? .white : viewModel.selectedDate.month == value.month ? .greyScale2 : .greyScale7)
                            }
                    }
                    .padding(10)
                    .frame(width: (UIScreen.main.bounds.width - 48) / 7)
                    .frame(height: 40)
                    .background(selectedDates.contains(value) ? Color.primary5 : Color.clear)
                    .clipShape(Circle())
                    .onTapGesture {
                        handleDateTap(value)
                        print("tap")
                        print("\(selectedDates)")
                    }
                    
                }
            }
        } //ZStack
        
    } //body
    
    func getLastDayOfMonth(date: Date) -> Int {
        let calendar = Calendar.current
        if let interval = calendar.range(of: .day, in: .month, for: date) {
            return interval.count
        }
        return 0
    }
    func handleDateTap(_ date: Date) {
        if selectedDates.count == 2 {
            selectedDates = [date]
        } else {
            selectedDates.append(date)
        }
        selectedDates.sort()
    }
    
    func validPeriod() -> Bool {
        for day in days {
            if let firstDate = selectedDates.first,
               let lastDate = selectedDates.last {
                if ((day >= firstDate && day <= lastDate) || (day >= firstDate && day <= lastDate)){
                    return true
                }
            }
        }
        return false
    }
}



//MARK: 피커 bottom sheet
struct PickerBottomSheet: View {
    @State var availableChangeTabbarStatus = false
    @Binding var showingTab : Bool
    @Binding var isShowing : Bool
    @Binding var yearMonth : YearMonthDuration
    //@ObservedObject var viewModel : CalculateViewModel
    let years = Array(2000...2099)
    let months = Array(1...12)

    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                        if availableChangeTabbarStatus {
                            showingTab = true
                        }
                    }
                    
                VStack {
                    HStack {
                        Spacer()
                        Button("완료") {
                            isShowing = false
                            if availableChangeTabbarStatus {
                                showingTab = true
                            }
                        }
                        .font(.pretendardFont(.semiBold, size: 16))
                        .foregroundColor(.greyScale2)
                        .padding()
                    }
                    YearMonthPicker(selection: $yearMonth, years: years, months: months)
                    // yearMonth가 바뀔 때마다 selectedDate가 바뀜
                }
                .frame(alignment: .bottom)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height / 3)
                .background(Color.greyScale12)
                .transition(.move(edge: .bottom))
                .cornerRadius(12, corners: [.allCorners])
            }
            
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }


}

