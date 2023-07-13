//
//  BottomSheet.swift
//  Floney
//
//  Created by 남경민 on 2023/04/13.
//


import SwiftUI
//import UIKit

enum BottomSheetType: Int {
    case accountBook = 0
    //case shareBook = 1
    
    func view() -> AnyView {
        switch self {
        case .accountBook:
            return AnyView(AccountBookBottomSheet())
            /*
             case .shareBook:
             return AnyView(ShareBookBottomSheet())*/
            
        }
    }
}

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
    @State var isLinktoCreateBook = false
    @State var tag:Int? = nil
    var body: some View{
        
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Text("가계부 추가")
                    .foregroundColor(.greyScale1)
                    .font(.pretendardFont(.bold,size: 18))
                Spacer()
            }
            .padding(.top, 24)
            
            
            
            VStack(spacing : 18) {
                NavigationLink(destination: SetBookNameView(), isActive: $isLinktoCreateBook) {
                    ButtonLarge(label: "가계부 생성하기",textColor: .greyScale1, strokeColor: .primary2, action: {
                        self.isLinktoCreateBook.toggle()
                    })
                    .frame(height: buttonHeight)
                }
                
                ButtonLarge(label: "코드 입력하기",textColor: .greyScale1, strokeColor: .greyScale9, action: {
                    
                })
                .frame(height: buttonHeight)
                
                ButtonLarge(label: "추가하기", background: .primary1, textColor: .white,  strokeColor: .primary1, fontWeight: .bold, action: {
                    
                })
                .frame(height: buttonHeight)
            }
        }
        .padding(.horizontal, 20)
        
    }
}

//MARK: 친구 초대하기 bottom sheet
struct ShareBookBottomSheet: View{
    var firebaseManager = FirebaseManager()
    let buttonHeight: CGFloat = 46
    @Binding var isShowing : Bool
    @Binding var bookCode : String
    @Binding var onShareSheet : Bool
    @Binding var shareUrl : URL?
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
                            ButtonLarge(label: "A9BC7ACE", background: .greyScale12, textColor: .greyScale2, strokeColor: .greyScale12, action: {
                                
                            })
                            .frame(height: buttonHeight)
                            
                        }
                        ButtonLarge(label: "공유하기",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                            //let url = firebaseManager.createDynamicLink(for: "A9BC7ACE")!
                            print("공유하기")
                            //shareUrl = url
                            isShowing = false
                            onShareSheet = true
                            
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
                
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        
    }
}

//MARK: 예산 설정 bottom sheet
struct SetBudgetBottomSheet: View {
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
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

//MARK: 초기 자산 설정 bottom sheet
struct SetInitialAssetBottomSheet: View {
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
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

//MARK: 이월 설정 bottom sheet
struct CarriedOverBottomSheet: View {
    let buttonHeight: CGFloat = 46
    @Binding var isShowing: Bool
    @Binding var onOff : Bool
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
                            self.onOff = false
                        } label: {
                            Text("OFF")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(onOff ? .greyScale8 : .primary2)
                                .frame(alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(onOff ? Color.greyScale8 : Color.primary2, lineWidth: 1) // Set the border
                        )
                        .frame(height: buttonHeight)
                        
                        Button {
                            self.onOff = true
                        } label: {
                            Text("ON")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(onOff ? .primary2 : .greyScale8)
                                .frame(alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(onOff ? Color.primary2 : Color.greyScale8, lineWidth: 1) // Set the border
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
    //@Binding var originalDateStr :String
    
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
                    
                    ScrollView {
                        VStack {
                            if viewModel.dayLines.count == 0 {
                                Image("no_line")
                                Text("내역이 없습니다.")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale6)
                            } else {
                                ForEach(viewModel.dayLines, id: \.self) { line in
                                    HStack {
                                        Image("icon_profile")
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("\(line!.content)")
                                                .font(.pretendardFont(.semiBold, size: 14))
                                                .foregroundColor(.greyScale2)
                                            HStack {
                                                ForEach(line!.category.indices, id: \.self) { index in
                                                    Text("\(line!.category[index])")
                                                        .font(.pretendardFont(.medium, size: 12))
                                                        .foregroundColor(.greyScale6)
                                                    if index != line!.category.count - 1 {
                                                        Text(" ‧ ")
                                                            .font(.pretendardFont(.medium, size: 12))
                                                            .foregroundColor(.greyScale6)
                                                    }
                                                }
                                            }
                                        }
                                        Spacer()
                                        if line!.assetType == "INCOME" {
                                            Text("+\(line!.money)")
                                                .font(.pretendardFont(.semiBold, size: 16))
                                                .foregroundColor(.greyScale2)
                                        } else if line!.assetType == "OUTCOME" {
                                            Text("-\(line!.money)")
                                                .font(.pretendardFont(.semiBold, size: 16))
                                                .foregroundColor(.greyScale2)
                                            
                                        }
                                    }
                                }
                            }
                            
                            
                            
                            
                        } // VStack
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .frame(height: 200)
                        //.background(Color.red)
                        .onAppear {
                            viewModel.dayLinesDate = viewModel.selectedDateStr
                            viewModel.getDayLines()
                        }
                    } //ScrollView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
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

                MonthView(viewModel: viewModel, pickerPresented: $pickerPresented)
                    
            }
            
        } //
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
        
        PickerBottomSheet(isShowing: $pickerPresented, yearMonth: $viewModel.yearMonth)
    }


}

struct MonthView: View {
    @ObservedObject var viewModel : CalculateViewModel
    @Binding var pickerPresented : Bool
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    
    
    var body: some View {
        @State var daysList = extractDate()
            VStack {
                HStack {
                    
                    Image("icon_left")
                        .onTapGesture {
                            // 한달 전으로 이동
                            viewModel.selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.selectedDate) ?? viewModel.selectedDate                    }
                    
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
                }.padding(.top, 20)
                    .padding(.bottom, 15)
            

               
                Group {
                    
                    ForEach(daysList.indices, id: \.self) { i in
                        Week(days: $daysList[i], selectedDates: $viewModel.selectedDates)
                    }
                }
                
                
                Spacer()
                
                Button {
                    //
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
                
    }
    
    private var yearAndMonthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM"
        return formatter
    }
    
    // Helper functions to calculate the number of days in the month and get a specific date
    func numberOfDaysInMonth() -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: viewModel.selectedDate)!
        return range.count
    }
    
    func daysInMonth() -> [Date] {
        var dates = [Date]()
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: viewModel.selectedDate)
        components.day = 1
        
        let firstDayOfMonth = calendar.date(from: components)!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let offsetDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        if let startDay = calendar.date(byAdding: .day, value: -offsetDays, to: firstDayOfMonth),
           let rangeOfMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth) {
            for i in 0..<(rangeOfMonth.count + offsetDays) {
                if let date = calendar.date(byAdding: .day, value: i, to: startDay) {
                    dates.append(date)
                }
            }
        }
        
        while dates.count % 7 != 0 {
            if let date = calendar.date(byAdding: .day, value: 1, to: dates.last!) {
                dates.append(date)
            }
        }
        
        return dates
    }
    // 이차원 배열 달력
    func extractDate() -> [[Date]] {
        var days = daysInMonth()
        //달력과 같은 배치의 이차원 배열로 변환하여 리턴
        var result = [[Date]]()
        days.forEach {
            if result.isEmpty || result.last?.count == 7 {
                result.append([$0])
            } else {
                result[result.count - 1].append($0)
            }
        }
        
        return result
    }
    
}


struct Week: View {
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
                ForEach(days.indices, id: \.self) { i in
                    CardView(value: days[i])
                        .onTapGesture {
                            handleDateTap(days[i])
                            print("tap")
                            print("\(selectedDates)")
                        }
                }
            }
        }
        
    } //body
    
    /**
     각각의 날짜에 대한 달력 칸 뷰
     */

    func CardView(value: Date) -> some View {
        VStack(spacing: 0) {
                if value.day > 0 {
                    Text("\(value.day)")
                        .padding()
                        .font(.pretendardFont(.regular,size: 14))
                        .foregroundColor(selectedDates.contains(value) ? .white : .greyScale2)
                        .background(selectedDates.contains(value) ? Color.primary5 : Color.clear)
                        .clipShape(Circle())
                }
        }
        .frame(width: (UIScreen.main.bounds.width - 48) / 7)
        .frame(height: 40)
        //.contentShape(Rectangle())
        //.background(Rectangle().stroke())
    }
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
                    }
                    
                VStack {
                    HStack {
                        Spacer()
                        Button("완료") {
                            isShowing = false
                        }
                        .font(.pretendardFont(.semiBold, size: 16))
                        .foregroundColor(.greyScale2)
                        .padding()
                    }
                    YearMonthPicker(selection: $yearMonth, years: years, months: months)
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

