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
                    .opacity(0.3)
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
                        ButtonLarge(label: (Keychain.getKeychainValue(forKey: .bookCode))!, background: .greyScale12, textColor: .greyScale2, strokeColor: .greyScale12, action: {
                            
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


struct SetBudgetBottomSheet: View{
    
    let buttonHeight: CGFloat = 46
    var body: some View{
       
            VStack(spacing: 24) {
                
                HStack {
                    Text("예산 설정")
                        .foregroundColor(.greyScale1)
                        .font(.pretendardFont(.bold,size: 18))
                    Spacer()
                }
                .padding(.top, 24)
                
                VStack(spacing : 28) {
                    ButtonLarge(label: "예산을 입력하세요", background: .greyScale12, textColor: .greyScale2, strokeColor: .greyScale12, action: {
                            
                        })
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
    }
}
