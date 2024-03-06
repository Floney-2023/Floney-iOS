//
//  BottomSheet.swift
//  Floney
//
//  Created by 남경민 on 2023/04/13.
//


import SwiftUI
import Kingfisher

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
    let scaler = Scaler.shared
    var buttonHeight: CGFloat {
        scaler.scaleHeight(46)
    }
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
                
                VStack(alignment: .leading, spacing: scaler.scaleHeight(12)) {
                    HStack {
                        Text("가계부 추가")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size: scaler.scaleWidth(18)))
                        Spacer()
                    }
                    .padding(.top, scaler.scaleHeight(24))
                    
                    VStack(alignment: .leading,spacing:scaler.scaleHeight(3)) {
                        Text("새로운 가계부를 추가할 방법을")
                        Text("선택해 주세요.")
                    }
                    .foregroundColor(.greyScale6)
                    .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                    .padding(.bottom, scaler.scaleHeight(8))
                    
                    VStack(spacing : scaler.scaleHeight(18)) {
                        Button {
                            isSelected = 0
                        } label: {
                            HStack {
                                ZStack {
                                    Text("가계부 생성하기")
                                        .frame(alignment: .center)
                                        .foregroundColor(isSelected == 0 ? .greyScale1 : .greyScale8)
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                                        .lineLimit(1)
                                    HStack {
                                        Spacer()
                                        Image(isSelected == 0 ? "icon_check_circle_activated" : "icon_check_circle_disabled")
                                            .padding(.trailing, scaler.scaleWidth(20))
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
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                                        .lineLimit(1)
                                    HStack {
                                        Spacer()
                                        Image(isSelected == 1 ? "icon_check_circle_activated" : "icon_check_circle_disabled")
                                            .padding(.trailing,scaler.scaleWidth(20))
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
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.bottom, scaler.scaleHeight(44))
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
    let scaler = Scaler.shared
    var appLinkManager = AppLinkManager()
    var buttonHeight: CGFloat {
        scaler.scaleHeight(46)
    }
    @ObservedObject var viewModel : SettingBookViewModel
    @Binding var isShowing : Bool
    @Binding var onShareSheet : Bool
    
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                VStack(spacing:scaler.scaleHeight(24)) {
                    HStack {
                        Text("친구들을 초대해서\n함께 가계부를 적어보세요🍀")
                            .lineSpacing(6)
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(18)))
                        Spacer()
                    }
                    .padding(.top, scaler.scaleHeight(24))
                    
                    VStack(spacing : scaler.scaleHeight(28)) {
                        VStack(spacing:scaler.scaleHeight(6)) {
                            HStack {
                                Text("초대 코드")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                    .foregroundColor(.greyScale8)
                                Spacer()
                            }
                            ButtonLarge(label: viewModel.bookCode,background: .greyScale12, isAbleCopied: true, textColor: .greyScale2, strokeColor: .greyScale12,fontWeight: .bold, action: {
                                
                            })
                            .frame(height: buttonHeight)
                            
                        }
                        ButtonLarge(label: "공유하기",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                            DispatchQueue.main.async {
                                let url = appLinkManager.generateDeepLink(inviteCode: viewModel.bookCode)
                                viewModel.shareUrl = url
                                onShareSheet = true
                                isShowing = false
                            }
                            
                        })
                        .frame(height: buttonHeight)
                        .onTapGesture {
                        }
                        
                    }
                    VStack(spacing:0) {
                        Text("나중에 하기")
                            .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                            .foregroundColor(.greyScale6)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: scaler.scaleWidth(55), height: scaler.scaleWidth(0.7))
                            .background(Color.greyScale6)
                    }
                    .onTapGesture {
                        isShowing = false
                    }
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.bottom, scaler.scaleHeight(34))
                .transition(.move(edge: .bottom))
                .background(
                    Color(.white)
                )
                .frame(width: scaler.scaleWidth(360))
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
    let scaler = Scaler.shared
    @State private var keyboardHeight: CGFloat = 0
    var buttonHeight: CGFloat {
        scaler.scaleHeight(46)
    }
    @State var label = "예산을 입력하세요."
    @Binding var isShowing: Bool
    @Binding var month : Int
    @ObservedObject var viewModel : SettingBookViewModel
    @State var budget : String = ""
    @State var realBudget : String = ""
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        budget = ""
                        isShowing.toggle()
                    }
                    .onAppear {
                        budget = viewModel.setBudgetDate(month: month)
                    }
                VStack(spacing: scaler.scaleHeight(20)) {
                    HStack(alignment:.center) {
                        Text("\(month)월 예산")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(16)))
                        Spacer()
                        VStack(spacing:0) {
                            Text("초기화하기")
                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                .foregroundColor(.greyScale6)
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: scaler.scaleWidth(52), height: scaler.scaleWidth(1))
                              .background(Color.greyScale6)
                            
                        }
                        .onTapGesture {
                            budget = ""
                        }
                    }
                    .padding(.horizontal,scaler.scaleWidth(4))
                    .padding(.top, scaler.scaleHeight(24))
                    
                    VStack(spacing : scaler.scaleHeight(20)) {
                        TextFieldLarge(label: $label, content: $budget)
                            .frame(height: buttonHeight)
                        ButtonLarge(label: "저장하기", background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                            if budget.isEmpty {
                                realBudget = "0"
                            } else {
                                realBudget = budget
                            }
                            if viewModel.onlyNumberValid(input: realBudget, budgetAssetType: .budget) {
                                isShowing = false
                            }
                        })
                        .frame(height: buttonHeight)
                    }
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.bottom, scaler.scaleHeight(30))
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
    let scaler = Scaler.shared
    @State private var keyboardHeight: CGFloat = 0
    var buttonHeight: CGFloat  {
        scaler.scaleHeight(46)
    }
    @State var label = "초기 자산을 입력하세요."
    @Binding var isShowing: Bool
    @ObservedObject var viewModel : SettingBookViewModel
    @State var initialAsset : String = ""
    @State var realinitialAsset : String = ""
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        initialAsset = ""
                        isShowing.toggle()
                    }
                    .onAppear {
                        Task {
                            self.initialAsset = await viewModel.getAsset() > 0 ? viewModel.getAsset().formattedString : ""
                        }
                    }
                VStack(spacing:scaler.scaleHeight(12)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("초기 자산 설정")
                                .foregroundColor(.greyScale1)
                                .font(.pretendardFont(.bold,size:scaler.scaleWidth(18)))
                        }
                        Spacer()
                        // 초기화
                        VStack(spacing:0) {
                            Text("초기화하기")
                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                .foregroundColor(.greyScale6)
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: scaler.scaleWidth(52), height: scaler.scaleWidth(1))
                              .background(Color.greyScale6)
                        }
                        .onTapGesture {
                            initialAsset = ""
                        }
                    }
                    .padding(.top,scaler.scaleHeight(24))
                    .padding(.horizontal,scaler.scaleWidth(4))
                    HStack {
                        Text("현재 모아놓은 자산을 입력해 주세요.\n플로니가 앞으로의 자산 흐름을 보여드릴게요.")
                            .lineSpacing(4)
                            .frame(alignment: .leading)
                            .foregroundColor(.greyScale6)
                            .font(.pretendardFont(.medium,size:scaler.scaleWidth(13)))
                        Spacer()
                    }.padding(.bottom, scaler.scaleHeight(8))
                        .padding(.horizontal,scaler.scaleWidth(4))
                    
                    VStack(spacing : scaler.scaleHeight(20)) {
                        TextFieldLarge(label: $label, content: $initialAsset)
                            .frame(height: buttonHeight)
                        ButtonLarge(label: "저장하기",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                            if initialAsset.isEmpty {
                                self.realinitialAsset = "0"
                            } else {
                                self.realinitialAsset = self.initialAsset
                            }
                            if viewModel.onlyNumberValid(input: realinitialAsset, budgetAssetType: .asset) {
                                initialAsset = ""
                                isShowing = false
                            }
                        })
                        .frame(height: buttonHeight)
                    }
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.bottom,scaler.scaleHeight(30))
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
    let scaler = Scaler.shared
    var buttonHeight: CGFloat {
        scaler.scaleHeight(46)
    }
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
                VStack(spacing:scaler.scaleHeight(24)) {
                    HStack {
                        Text("이월 설정")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(18)))
                        Spacer()
                    }
                    .padding(.top, scaler.scaleHeight(24))
                    .padding(.horizontal, scaler.scaleWidth(4))
                    
                    HStack {
                        Text("지난달 총수입")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(11)))
                            .foregroundColor(.greyScale2)
                            .background(Color.background2)
                            .cornerRadius(10)
                        Image("-")
                        Text("지난달 총지출")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(11)))
                            .foregroundColor(.greyScale2)
                            .background(Color.background2)
                            .cornerRadius(10)
                        Image("=")
                        Text("다음달 시작금액")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(11)))
                            .foregroundColor(.white)
                            .background(Color.primary5)
                            .cornerRadius(10)
                    }
                    HStack{
                        Text("이월 설정은 지난 달에 기록된 수입에서 지출을 차감한 금액을\n다음 달로 넘기는 기능입니다.")
                            .lineSpacing(4)
                            .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                            .foregroundColor(.greyScale2)
                        Spacer()
                    }
                    .padding(.horizontal, scaler.scaleWidth(4))
                    HStack {
                        Text("남은 금액이 마이너스 인 경우 지출로 기록되며\n플러스인 경우는 수입으로 기록됩니다.")
                            .lineSpacing(4)
                            .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                            .foregroundColor(.greyScale2)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, scaler.scaleWidth(4))
                    HStack {
                        Button {
                            //self.onOff = false
                            viewModel.setCarryOver(status: false)
                        } label: {
                            Text("OFF")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(viewModel.carryOver ? .greyScale8 : .primary2)
                                .frame(alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, scaler.scaleHeight(16))
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
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(viewModel.carryOver ? .primary2 : .greyScale8)
                                .frame(alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, scaler.scaleHeight(16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.carryOver ? Color.primary2 : Color.greyScale8, lineWidth: 1) // Set the border
                        )
                        .frame(height: buttonHeight)
                        
                    }.frame(maxWidth: .infinity)
                        .padding(.top, scaler.scaleHeight(12))
                    
                } //VStack
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.bottom, scaler.scaleHeight(30))
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
    let scaler = Scaler.shared
    var buttonHeight: CGFloat {
        scaler.scaleHeight(46)
    }
    @Binding var root : String
    @Binding var categories : [String]
    @Binding var isShowing: Bool
    @Binding var isSelectedAssetTypeIndex : Int
    @Binding var isSelectedAssetType : String
    @Binding var isSelectedCategoryIndex : Int
    @Binding var isSelectedCategory : String
    @Binding var isShowingEditCategory : Bool
    @State var selectedAssetIndex = 0
    @State var selectedCategoryIndex = 0
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
                VStack(spacing:scaler.scaleHeight(12)) {
                    HStack {
                        Text(root == "자산" ? "자산" : "분류")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(18)))
                        Spacer()
                        
                        Button  {
                            isShowingEditCategory = true
 
                        } label: {
                            Text("편집")
                                .foregroundColor(.greyScale4)
                                .font(.pretendardFont(.regular,size: scaler.scaleWidth(14)))
                        }
                        
                    }
                    .padding(.top,scaler.scaleHeight(24))
                    .padding(.bottom,scaler.scaleHeight(6))
                    
                    CategoryFlowLayout(root: $root,
                                       categories: $categories,
                                       isSelectedAssetTypeIndex: $isSelectedAssetTypeIndex,
                                       isSelectedAssetType: $isSelectedAssetType,
                                       isSelectedCategoryIndex: $isSelectedCategoryIndex,
                                       isSelectedCategory: $isSelectedCategory,
                                       isShowing: $isShowing,
                                       selectedAssetIndex: $selectedAssetIndex,
                                       selectedCategoryIndex: $selectedCategoryIndex
                    )
                    
                    //Spacer()
                    ButtonLarge(label: "확인",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                        if root == "자산" {
                            self.isSelectedAssetTypeIndex = selectedAssetIndex
                            isSelectedAssetType = categories[selectedAssetIndex]
                        } else {
                            self.isSelectedCategoryIndex = selectedCategoryIndex
                            isSelectedCategory = categories[selectedCategoryIndex]
                        }
                        isShowing.toggle()
                    })
                    .frame(height: buttonHeight)
  
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.bottom, scaler.scaleHeight(30))
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
    let scaler = Scaler.shared
    
    @Binding var root : String
    @State private var totalWidth = CGFloat.zero
    @Binding var categories: [String]
    @Binding var isSelectedAssetTypeIndex : Int
    @Binding var isSelectedAssetType : String
    @Binding var isSelectedCategoryIndex : Int
    @Binding var isSelectedCategory : String
    @Binding var isShowing: Bool
    
    @Binding var selectedAssetIndex : Int
    @Binding var selectedCategoryIndex : Int
    
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
        var verticalSpacing: CGFloat {
            scaler.scaleHeight(12)
        }
        
        return
        ScrollView(showsIndicators:false) {
            ZStack(alignment: .topLeading) {
                ForEach(self.categories.indices, id: \.self) { index in
                    CategoryButton(
                        label: self.categories[index],
                        isSelected: root == "자산" ? selectedAssetIndex == index : selectedCategoryIndex == index,
                        action: {
                            
                            if root == "자산" {
                                selectedAssetIndex = index
                            } else {
                                selectedCategoryIndex = index
                            }
                        }
                    )
                    .padding([.horizontal],scaler.scaleWidth(4))
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
            .padding(.top, 1)
        }
    }
}

struct DayLinesBottomSheet: View {
    let scaler = Scaler.shared
    let buttonHeight: CGFloat = 38
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var isShowing: Bool
    @Binding var isShowingAddView : Bool
    @State var showingDetail = false
    @State private var selectedIndex = 0
    @State var selectedToggleTypeIndex = 0
    @State var selectedToggleType = ""
    @StateObject var lineModel = LineModel()
    
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
                VStack(spacing:0) {
                    HStack {
                        VStack(alignment: .leading, spacing: scaler.scaleHeight(8)) {
                            Text("\(year)년")
                                .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale6)
                            Text("\(viewModel.selectedMonth)월 \(viewModel.selectedDay)일")
                                .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                                .foregroundColor(.greyScale1)
                            
                        }
                        .padding(.top, scaler.scaleHeight(20))
                        .padding(.bottom, scaler.scaleHeight(12))
                        Spacer()
                        VStack {
                            Text("내역 추가")
                                .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(12)))
                                .foregroundColor(.primary2)
                                .padding(.top, scaler.scaleHeight(33))
                                .padding(.bottom, scaler.scaleHeight(25))
                                .onTapGesture {
                                    isShowing.toggle()
                                    self.isShowingAddView.toggle()
                                }
                        }
                    }
                    
                    VStack(spacing:0) {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing:scaler.scaleHeight(38)) {
                                if Calendar.current.component(.day, from: viewModel.selectedDate) == 1 {
                                    if viewModel.dayLineCarryOver.carryOverStatus {
                                        HStack(spacing:scaler.scaleWidth(16)) {
                                            if viewModel.seeProfileImg {
                                                Image("book_profile_32")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                                
                                            }
                                            VStack(alignment: .leading, spacing: scaler.scaleHeight(8)){
                                                Text("이월")
                                                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                                    .foregroundColor(.greyScale2)
                                                Text("-")
                                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                                    .foregroundColor(.greyScale6)
                                            }
                                            Spacer()
                                            Text("\(viewModel.dayLineCarryOver.carryOverMoney.formattedString)")
                                                .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                                                .foregroundColor(.greyScale2)
                                        }
                                        .frame(height: scaler.scaleHeight(34))
                                        
                                    }
                                }
                                if viewModel.dayLines.count == 0 {
                                    // 1일이고, 이월금액이 존재한다면
                                    if Calendar.current.component(.day, from: viewModel.selectedDate) == 1 && viewModel.dayLineCarryOver.carryOverStatus {
                                        
                                    } else {
                                        Spacer()
                                        VStack(spacing:scaler.scaleHeight(10)) {
                                            Image("no_line")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: scaler.scaleWidth(38), height: scaler.scaleWidth(64))
                                           
                                            Text("내역이 없습니다.")
                                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                                .foregroundColor(.greyScale6)
                                            
                                        }
                                        .frame(maxHeight: .infinity)
                                        Spacer()
                                        
                                    }
                                } else {
                                    ForEach(viewModel.dayLines.indices, id: \.self) { index in
                                        HStack(spacing:scaler.scaleWidth(16)) {
                                            if viewModel.seeProfileImg {
                                                if let userImg = viewModel.userImages {
                                                    if let img = userImg[index] {
                                                        if img == "user_default" {
                                                            Image("user_profile_32")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fill)
                                                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                                .clipShape(Circle())
                                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                                             
                                                            
                                                        } else if img.hasPrefix("random"){
                                                            let components = img.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                                            let random = components.first!  // "random"
                                                            let number = components.last!   // "5"
                                                            Image("img_user_random_profile_0\(number)_32")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fill)
                                                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                                .clipShape(Circle())
                                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                                         
                                                        }
                                                        else  {
                                                            
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
                                                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                                .clipShape(Circle())
                                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                                            
                                                        }
                                                    } else { //null
                                                        Image("user_profile_32")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                            .clipShape(Circle())
                                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                    
                                                    }
                                                } else {
                                                    Image("user_profile_32")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                        .clipShape(Circle())
                                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                                    
                                                }
                                            }
                                            if let line = viewModel.dayLines[index] {
                                                VStack(alignment: .leading, spacing:scaler.scaleHeight(8)) {
                                                    Text("\(line.content)")
                                                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                                        .foregroundColor(.greyScale2)
                                                    HStack(spacing:0) {
                                                        ForEach(Array(line.category.enumerated()), id: \.element) { categoryIndex, category in
                                                            Text("\(category)")
                                                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                                                .foregroundColor(.greyScale6)
                                                            // 마지막 요소가 아닐 경우에만 점을 추가
                                                            if categoryIndex < line.category.count - 1 {
                                                                Text(" ‧ ")
                                                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                                                    .foregroundColor(.greyScale6)
                                                            }
                                                        }
                                                        
                                                        
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                if line.assetType == "INCOME" {
                                                    Text("+\(line.money.formattedString)")
                                                        .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(16)))
                                                        .foregroundColor(.greyScale2)
                                                } else if line.assetType == "OUTCOME" {
                                                    Text("-\(line.money.formattedString)")
                                                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                                                        .foregroundColor(.greyScale2)
                                                    
                                                } else if line.assetType == "BANK" {
                                                    Text("-\(line.money.formattedString)")
                                                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                                                        .foregroundColor(.greyScale2)
                                                    
                                                }
                                            }
                                        }
                                        .background(Color.white)
                                        .onTapGesture {
                                            LoadingManager.shared.update(showLoading: true, loadingType: .progressLoading)
                                            self.selectedIndex = index
                                            
                                            if let line = viewModel.dayLines[selectedIndex] {
                                                if viewModel.dayLines[index]?.assetType == "OUTCOME" {
                                                    selectedToggleTypeIndex = 0
                                                    selectedToggleType = "지출"
                                                } else if viewModel.dayLines[index]?.assetType == "INCOME" {
                                                    selectedToggleTypeIndex = 1
                                                    selectedToggleType = "수입"
                                                } else if viewModel.dayLines[index]?.assetType == "BANK" {
                                                    selectedToggleTypeIndex = 2
                                                    selectedToggleType = "이체"
                                                }
                                                
                                            }
                             
                                            LoadingManager.shared.update(showLoading: false, loadingType: .progressLoading)
                                            self.showingDetail = true
                                                
                                            
                                        }
                                        .frame(height: scaler.scaleHeight(34))
                                        .fullScreenCover(isPresented: $showingDetail) {
                                            if let line = viewModel.dayLines[selectedIndex] {
                                                NavigationView {
                                                    AddView(
                                                        isPresented: $showingDetail,
                                                        mode : "check",
                                                        lineId : line.id,
                                                        toggleType : selectedToggleType, // 지출, 수입, 이체
                                                        selectedOptions : selectedToggleTypeIndex,
                                                        date : viewModel.selectedDateStr,
                                                        money: String(line.money.formattedString),
                                                        assetType : line.category[0],
                                                        category: line.category[1],
                                                        content : line.content,
                                                        toggleOnOff: line.exceptStatus,
                                                        writer: line.userNickName
                                                    )
                                                                                                        
                                                }
                                                .transition(.moveAndFade)
                                                .navigationViewStyle(.stack)
                                            }
                                        }
                                    } //ForEach
                                } // else
                            }.padding(.top, scaler.scaleHeight(18))
                            .padding(.bottom, scaler.scaleHeight(94))
                        } //ScrollView
                        
                    }
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .transition(.move(edge: .bottom))
                .frame(height: scaler.scaleHeight(460))
                .background(
                    Color(.white)
                )
                .cornerRadius(12, corners: [.topLeft, .topRight])
                .onAppear {
                    viewModel.dayLinesDate = viewModel.selectedDateStr
                    viewModel.getDayLines()
                }
                .onChange(of : isShowingAddView) { newValue in
                    viewModel.getDayLines()
                    viewModel.getCalendar()
                }
                .onChange(of : showingDetail) { newValue in
                    viewModel.getDayLines()
                    viewModel.getCalendar()
                }
            } // if
        } //ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        
    }
}

//MARK: 임시 비밀번호 완료 bottom sheet
struct PasswordBottomSheet: View{
    let scaler = Scaler.shared
    var buttonHeight: CGFloat {
        scaler.scaleHeight(46)
    }
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
                VStack(spacing: scaler.scaleHeight(16)) {
                    HStack {
                        Text("임시 비밀번호가\n발송되었습니다.")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size: scaler.scaleWidth(18)))
                        Spacer()
                    }
                    .padding(.horizontal,  scaler.scaleWidth(24))
                    .padding(.top, scaler.scaleHeight(24))
                    
                    VStack(spacing : scaler.scaleHeight(32)) {
                        
                        HStack {
                            Text("임시 비밀번호로 로그인 후\n새로운 비밀번호로 변경해 주세요.")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                                .foregroundColor(.greyScale6)
                            Spacer()
                        }.padding(.horizontal,  scaler.scaleWidth(4))
                        
                        
                        ButtonLarge(label: "다시 로그인하기",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                            isShowing = false
                            isShowingLogin = true
                        })
                        .frame(width: scaler.scaleWidth(320))
                        .frame(height: buttonHeight)
                    }
                    .padding(.horizontal,  scaler.scaleWidth(20))
                }
                .ignoresSafeArea()
                .frame(width: scaler.scaleWidth(360))
                //.frame(height: scaler.scaleHeight(248))
                .padding(.bottom, scaler.scaleHeight(44))
                .transition(.move(edge: .bottom))
                .background(Color.white)
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
//MARK: 예산 연도 설정 PICKER
struct YearPickerSheetView: View {
    @Binding var selectedYear: Int
    let years: [Int] = Array(1990...2099)
    var body: some View {
        VStack {
            Picker("Select Year", selection: $selectedYear) {
                ForEach(years, id: \.self) { year in
                    Text("\(String(year))").tag(year)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
        }
        .padding()
        
    }
}
//MARK: 예산 연도 설정
struct YearBottomSheet: View {
    @Binding var selectedYear: Int
    @Binding var isShowing: Bool
    
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                VStack() {
                    YearPickerSheetView(selectedYear: $selectedYear)
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
struct AddCalendarBottomSheet: View {
    let buttonHeight: CGFloat = 46
    @Binding var isShowing : Bool
    @ObservedObject var viewModel : AddViewModel
    @State var pickerPresented = false
    @State var showingTab = false
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                        viewModel.convertStringToDate(viewModel.selectedDateStr)
                    }
                AddMonthView(viewModel: viewModel, isShowing: $isShowing, pickerPresented: $pickerPresented)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        PickerBottomSheet(showingTab: $showingTab, isShowing: $pickerPresented, yearMonth: $viewModel.presentedYearMonth)
    }

}

struct AddMonthView: View {
    @ObservedObject var viewModel : AddViewModel
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
                        viewModel.presentedDate = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.presentedDate) ?? viewModel.presentedDate
                }
                Spacer()
                
                Button(action: {
                    self.pickerPresented = true
                }) {
                    Text("\(yearAndMonthFormatter.string(from:viewModel.presentedDate))")
                        .font(.pretendardFont(.semiBold, size: 22))
                        .foregroundColor(.greyScale2)
                }
                
                Spacer()
                
                Image("icon_right")
                    .onTapGesture {
                        // 한달 후로 이동
                        viewModel.presentedDate = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.presentedDate) ?? viewModel.presentedDate
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
            ForEach(viewModel.daysList.indices, id: \.self) { i in
                AddWeek(viewModel: viewModel, days: $weeks[i])
            }
            Spacer()
            //MARK: 선택하기 버튼
            Button {
                viewModel.convertDateToString(viewModel.selectedDate)
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
struct AddWeek: View {
    @ObservedObject var viewModel : AddViewModel
    @Binding var days : [Date]
    let colWidth = UIScreen.main.bounds.width / 7
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { value in
                    VStack(spacing: 0) {
                        if value.day > 0 {
                            Text("\(value.day)")
                                .font(.pretendardFont(.regular,size: 14))
                                .foregroundColor(viewModel.selectedDate == value ? .white : viewModel.presentedDate.month == value.month ? .greyScale2 : .greyScale7)
                        }
                    }
                    .padding(10)
                    .frame(width: (UIScreen.main.bounds.width - 48) / 7)
                    .frame(height: 40)
                    .background(viewModel.selectedDate == value ? Color.primary5 : Color.clear)
                    .clipShape(Circle())
                    .onTapGesture {
                        viewModel.selectedDate = value
                    }
                    
                }
            }
        }
    }
}

struct SetExcelDurationBottomSheet: View {
    let scaler = Scaler.shared
    var buttonHeight: CGFloat {
        scaler.scaleHeight(46)
    }
    @ObservedObject var viewModel : SettingBookViewModel
    @Binding var isShowing: Bool
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                //MARK: Background
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.selectedExcelDuration = .thisMonth
                        isShowing.toggle()
                    }
                //MARK: content
                VStack(spacing:scaler.scaleHeight(18)) {
                    HStack {
                        Text("엑셀 내보내기")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(18)))
                        Spacer()
                    }
                    .padding(.top,scaler.scaleHeight(24))
                    
                    SetExcelDurationFlowLayout(
                        viewModel:viewModel,
                        isShowing: $isShowing
                    )
                    Spacer()
                    ButtonLarge(label: "내보내기",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                        viewModel.downloadExcelFile()
                        isShowing.toggle()
                    })
                    .frame(height: buttonHeight)
  
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.bottom, scaler.scaleHeight(30))
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

struct SetExcelDurationFlowLayout: View {
    let scaler = Scaler.shared
    @ObservedObject var viewModel : SettingBookViewModel
    @State private var totalWidth = CGFloat.zero
    @Binding var isShowing: Bool
    @State var selectedDurationIndex : Int = 0
    
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
        var verticalSpacing: CGFloat {
            scaler.scaleHeight(12)
        }
        return ZStack(alignment: .topLeading) {
            ForEach(viewModel.durationOptions.indices, id: \.self) { index in
                CategoryButton(
                    label: viewModel.durationOptions[index],
                    isSelected: selectedDurationIndex == index,
                    action: {
                        selectedDurationIndex = index
                        viewModel.handleUserSelection(viewModel.durationOptions[index])
                    }
                )
                .padding([.horizontal],scaler.scaleWidth(4))
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height + verticalSpacing
                    }
                    let result = width
                    if index < viewModel.durationOptions.count - 1 {
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

struct RepeatDurationBottomSheet: View {
    let scaler = Scaler.shared
    var buttonHeight: CGFloat {
        scaler.scaleHeight(46)
    }
    @ObservedObject var viewModel : AddViewModel
    @State var selectedDurationIndex: Int = 0
    @Binding var isShowing: Bool
    var body: some View{
        ZStack(alignment: .bottom) {
            if (isShowing) {
                //MARK: Background
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedDurationIndex = viewModel.selectedDurationIndex
                        isShowing.toggle()
                    }
                //MARK: content
                VStack(spacing:scaler.scaleHeight(18)) {
                    HStack {
                        Text("반복 설정")
                            .foregroundColor(.greyScale1)
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(18)))
                        Spacer()
                    }
                    .padding(.top,scaler.scaleHeight(24))
                    
                    RepeatDurationFlowLayout(
                        viewModel: viewModel,
                        isShowing: $isShowing,
                        selectedDurationIndex: $selectedDurationIndex
                    )
                    Spacer()
                    ButtonLarge(label: "확인",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                        viewModel.handleUserSelection(viewModel.durationOptions[selectedDurationIndex], index: selectedDurationIndex)
                        isShowing.toggle()
                        
                    })
                    .frame(height: buttonHeight)
  
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.bottom, scaler.scaleHeight(30))
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

struct RepeatDurationFlowLayout: View {
    let scaler = Scaler.shared
    @ObservedObject var viewModel : AddViewModel
    @State private var totalWidth = CGFloat.zero
    @Binding var isShowing: Bool
    @Binding var selectedDurationIndex : Int
    
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
        var verticalSpacing: CGFloat {
            scaler.scaleHeight(12)
        }
        return ZStack(alignment: .topLeading) {
            ForEach(viewModel.durationOptions.indices, id: \.self) { index in
                CategoryButton(
                    label: viewModel.durationOptions[index],
                    isSelected: selectedDurationIndex == index,
                    action: {
                        selectedDurationIndex = index
                    }
                )
                .padding([.horizontal],scaler.scaleWidth(4))
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height + verticalSpacing
                    }
                    let result = width
                    if index < viewModel.durationOptions.count - 1 {
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

