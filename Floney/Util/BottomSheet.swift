//
//  BottomSheet.swift
//  Floney
//
//  Created by 남경민 on 2023/04/13.
//


import SwiftUI

enum BottomSheetType: Int {
    case accountBook = 0
    case shareBook = 1
    
    func view() -> AnyView {
        switch self {
        case .accountBook:
            return AnyView(AccountBookBottomSheet())
        case .shareBook:
            return AnyView(ShareBookBottomSheet())
            
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
    let buttonHeight: CGFloat = 46
    var body: some View{
        
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
                    ButtonLarge(label: "FLONEY", background: .greyScale12, textColor: .greyScale2, strokeColor: .greyScale12, action: {
                        
                    })
                    .frame(height: buttonHeight)
                    
                }
                ButtonLarge(label: "공유하기",background: .primary1, textColor: .white, strokeColor: .primary1,  fontWeight: .bold, action: {
                    
                })
                .frame(height: buttonHeight)
                
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
    }
}

//MARK: 예산 설정 bottom sheet
struct SetBudgetBottomSheet: View {
    let buttonHeight: CGFloat = 46
    @State var label = "예산을 입력하세요."
    @Binding var isShowing: Bool
    @Binding var budget : String
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
    @Binding var initialAsset : String
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



