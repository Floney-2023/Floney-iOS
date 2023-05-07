//
//  AuthCodeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/17.
//

import SwiftUI

@available(iOS 15.0, *)
struct AuthCodeView: View {
    @StateObject var otpModel : OTPViewModel = .init()
    // MARK: TextField Focus State
    @FocusState var activeField : OTPField?
    @State var email = ""
    var pageCount = 3
    var pageCountAll = 4
    var body: some View {
        VStack(spacing: 32) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(pageCount)")
                        .foregroundColor(.greyScale2)
                    + Text(" / \(pageCountAll)")
                        .foregroundColor(.greyScale6)
                    
                    Text("인증 코드 입력")
                        .font(.pretendardFont(.bold, size: 24))
                        .foregroundColor(.greyScale1)
                    
                    Text("이메일로 전송된 코드를\n하단에 입력해주세요.")
                        .font(.pretendardFont(.medium, size: 13))
                        .foregroundColor(.greyScale6)
                }
                Spacer()
            }
            OTPField()
            Spacer()
            NavigationLink(destination: UserInfoView()){
                Text("다음으로")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    
            }
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .onChange(of: otpModel.otpFields) { newValue in
            OTPCondition(value: newValue)
        }
    }
    
    // MARK: Conditions For Custom OTP Field & Limiting Only one Text
    func OTPCondition(value : [String]) {
        // Moving Next Field If Current Field Type
        for index in 0..<5 {
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField {
                activeField = activeStateForIndex(index: index + 1)
            }
        }
        
        // Moving Back if Current is Empty And Previous is not Empty
        for index in 1...5 {
            if value[index].isEmpty && !value[index-1].isEmpty {
                activeField = activeStateForIndex(index: index-1)
            }
        }
        
        for index in 0..<6 {
            if value[index].count > 1 {
                otpModel.otpFields[index] = String(value[index].last!)
                
            }
        }
    }
    
    // MARK: Custom OTP TextField
    @ViewBuilder
    func OTPField()->some View {
        HStack(spacing:14) {
            ForEach(0..<6, id: \.self){ index in
                VStack(spacing:8) {
                    TextField("", text: $otpModel.otpFields[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField, equals: activeStateForIndex(index: index))
                    
                    Rectangle()
                        .fill(activeField == activeStateForIndex(index: index) ? Color.primary3 : Color.greyScale9)
                        .frame(height: 4)
                }
                .frame(width: 40)
            }
            
        }
    }
    
    func activeStateForIndex(index: Int)->OTPField{
        switch index {
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        default: return .field6
            
        }
    }
}

struct AuthCodeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            AuthCodeView()
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK: FocusState Enum
enum OTPField{
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6
}
