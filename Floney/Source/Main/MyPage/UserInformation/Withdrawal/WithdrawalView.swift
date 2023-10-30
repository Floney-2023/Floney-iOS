//
//  WithdrawalView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/26.
//

import SwiftUI

enum SignOutType : String, CaseIterable {
    case NOT_KNOW_HOW_TO_USE = "NOT_KNOW_HOW_TO_USE"
    case EXPENSIVE = "EXPENSIVE"
    case NOT_USE_OFTEN = "NOT_USE_OFTEN"
    case WILL_SIGNUP_AGAIN = "WILL_SIGNUP_AGAIN"
    case OTHER = "OTHER"
    
    var reason : String {
        switch self {
        case .NOT_KNOW_HOW_TO_USE :
            return "플로니를 어떻게 사용하는지 모르겠어요"
        case .EXPENSIVE:
            return "구독료가 비싸요"
        case .NOT_USE_OFTEN:
            return "자주 사용하지 않게 돼요"
        case .WILL_SIGNUP_AGAIN:
            return "다시 가입할 거예요"
        case .OTHER:
            return "직접 입력하기"
        }
    }
    
}

struct WithdrawalView: View {
    let scaler = Scaler.shared
    @StateObject var viewModel = MyPageViewModel()
    @State var signoutAlert = false
    @State var title = "탈퇴하기"
    @State var message = "정말 탈퇴하시겠습니까?"
    init() {
        print("회원탈퇴 뷰 로딩 완료")
    }
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                        VStack(alignment: .leading, spacing: scaler.scaleHeight(5)) {
                            Text("회원탈퇴 전")
                            Text("이유를 선택해주세요 😢")
                        }
                        .font(.pretendardFont(.bold, size:scaler.scaleWidth(24)))
                        .foregroundColor(.greyScale1)
                        VStack(alignment: .leading, spacing: scaler.scaleHeight(3)) {
                            Text("잠깐! 탈퇴 시 가계부 기록이")
                            
                            Text("모두 삭제 됩니다.")
                                
                        }
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                        .foregroundColor(.greyScale6)
                    }
                    Spacer()
                }
                .padding(.horizontal,scaler.scaleWidth(4))
                .padding(.bottom, scaler.scaleHeight(18))
                
                VStack(spacing: 0) {
                    ForEach(SignOutType.allCases, id: \.self) { reason in
                        HStack {
                            Text(reason.reason)
                                .padding(.leading,scaler.scaleWidth(4))
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale2)
                            Spacer()
                            Image(viewModel.selectedReason == reason ? "check_primary" : "checkbox_grey")
                        }
                        .frame(height:scaler.scaleHeight(54))
                        .onTapGesture {
                            if reason == .OTHER {
                                // Do Nothing, text input will handle this case
                                viewModel.selectedReason = reason
                            } else {
                                viewModel.selectedReason = (viewModel.selectedReason == reason) ? nil : reason
                            }
                        }
                    }
                    
                    TextField("이유를 작성해 주세요 (100자 이내)", text: $viewModel.otherReason)
                        .padding()
                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale2)
                        .frame(height:scaler.scaleHeight(140))
                        .background(Color.background3)
                        .cornerRadius(12)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)

                }
                  
                Spacer()
                Text("탈퇴하기")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        if viewModel.isValidSignout() {
                            signoutAlert = true
                        }
                    }
                    .padding(.bottom, scaler.scaleHeight(38))
            }
            .padding(EdgeInsets(top:scaler.scaleHeight(30), leading:scaler.scaleWidth(20), bottom: 0, trailing:scaler.scaleWidth(20)))
            .customNavigationBar(
                leftView: { BackButton() }
            )
            
            .edgesIgnoringSafeArea(.bottom)
            
            if signoutAlert {
                AlertView(isPresented: $signoutAlert,title: $title, message: $message, okColor: .alertBlue, onOKAction: {
                    viewModel.signout()
                })
            }
        }
    }
}

struct WithdrawalView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalView()
    }
}
