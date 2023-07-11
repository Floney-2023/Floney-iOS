//
//  CustomAlert.swift
//  Floney
//
//  Created by 남경민 on 2023/05/13.
//

import SwiftUI


enum ErrorMessage {
    case login01
    
    case signup01
    case signup02
    case signup03
    case signup04
    case signup05
    case signup06
    case signup07
    case signup08
    case signup09
    case signup10
    case signup11
    
    case createBook01
    
    case enterBookCode01
    case enterBookCode02
    case enterBookCode03
    case enterBookCode04
    
    case findPassword01
    case findPassword02
    
    var value: String {
        switch self {
        case .login01:
            return "이메일 또는 비밀번호를 다시 확인해주세요."
        case .signup01:
            return "필수약관에 모두 동의해주세요."
        case .signup02:
            return "이메일 주소를 입력해주세요."
        case .signup03:
            return "유효한 이메일을 입력해주세요."
        case .signup04:
            return "이미 등록된 이메일 입니다."
        case .signup05:
            return "코드가 올바르지 않습니다."
        case .signup06:
            return "유효 시간이 초과되었습니다. 다시 시도해 주세요."
        case .signup07:
            return "비밀번호를 입력해주세요."
        case .signup08:
            return "비밀번호 확인을 입력해주세요."
        case .signup09:
            return "비밀번호 양식을 확인해주세요."
        case .signup10:
            return "비밀번호가 일치하지 않습니다."
        case .signup11:
            return "닉네임을 입력해주세요."
        case .createBook01:
            return "이름을 입력하세요."
        case .enterBookCode01:
            return "코드를 입력하세요."
        case .enterBookCode02:
            return "존재하지 않는 코드입니다."
        case .enterBookCode03:
            return "이미 사용자가 가득 찬 가계부 입니다."
        case .enterBookCode04:
            return "이미 생성된 가계부 2개를 사용하고 있습니다."
        case .findPassword01:
            return "유효한 이메일을 입력해주세요"
        case .findPassword02:
            return "일치하는 회원이 없습니다."
            
        }
        
        
        func errorMessage(_ type: ErrorMessage) -> String {
            return type.value
        }
    }
}

struct CustomAlertView: View {
    var message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        
        if (isPresented) {
            VStack{
                Spacer()
                VStack {
                    
                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            Image("icon_cancel_circle_white")
                        }
                        
                        Text(message)
                            .foregroundColor(Color.white)
                            .font(.pretendardFont(.medium,size: 14))
                        Spacer()
                    }.padding(.leading)
                    
                }
                .frame(width: 360, height: 46)
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 10)
                .animation(.easeInOut, value: isPresented)
                .transition(.move(edge: .bottom))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isPresented = false
                    }
                }
            }
            
        }
    }
    
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(message:"error message", isPresented: .constant(true))
    }
}
