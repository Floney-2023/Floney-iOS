//
//  AuthCodeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/17.
//

import SwiftUI

@available(iOS 15.0, *)
struct AuthCodeView: View {
    let scaler = Scaler.shared
    @State private var remainingTime: Double = 5 * 60 // 초 단위로 5분
    @State private var startTime = Date.now
    @Environment(\.scenePhase) var scenePhase
       
    @StateObject var otpModel : OTPViewModel = .init()
    @ObservedObject var viewModel : SignUpViewModel
    // MARK: TextField Focus State
    @FocusState var activeField : OTPField?
    @State var email = ""
    var pageCount = 3
    var pageCountAll = 4
    var body: some View {
        VStack(spacing: scaler.scaleHeight(24)) {
            HStack {
                VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                    Text("\(pageCount)")
                        .foregroundColor(.greyScale2)
                        .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                    + Text(" / \(pageCountAll)")
                        .foregroundColor(.greyScale6)
                        .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                    
                    Text("인증 코드 입력")
                        .font(.pretendardFont(.bold, size: scaler.scaleWidth(24)))
                        .foregroundColor(.greyScale1)
                    
                    Text("이메일로 전송된 코드를\n하단에 입력해주세요.")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                        .foregroundColor(.greyScale6)
                }
                Spacer()
            }
            .padding(.bottom, scaler.scaleHeight(40))
            
            OTPField()
            
            Text(getTimeString(time:remainingTime))
                .padding(scaler.scaleWidth(6))
                .font(.pretendardFont(.medium,size:scaler.scaleWidth(20)))
                .foregroundColor(.primary2)
                .background(Color.primary10)
                .cornerRadius(8)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { Timer in
                        if self.remainingTime > 0 {
                            self.remainingTime -= 1
                        } else {
                            Timer.invalidate()
                        }
                    })
                    
                }
                .onChange(of: scenePhase) { newScenePhase in
                    switch newScenePhase {
                    case .active:
                        print("active")
                        // 앱이 전면으로 왔을 때
                        bgTimer()
                    case .inactive:
                        print("Inactive")
                    case .background:
                        print("background")
                        // 앱이 백그라운드로 갈 때
                    @unknown default:
                        print("scenePhase err")
                    }
                }
                .padding(.bottom, scaler.scaleHeight(24))
            HStack {
                VStack(alignment: .leading, spacing:scaler.scaleHeight(5)) {
                    Text("-유효 시간이 지났을 경우 인증 메일을 다시 보내주세요.")
                        
                    Text("-하루동안 5번까지 새로운 인증 코드를 받을 수 있습니다.")
                        
                    Text("-5번 연속 코드 입력에 실패했다면 24시간 이후 시도해주세요.")
                        
                }
                Spacer()
            }
            .font(.pretendardFont(.regular,size: scaler.scaleWidth(12)))
            .foregroundColor(.greyScale6)
            Spacer()
            NavigationLink(destination: UserInfoView(viewModel: viewModel), isActive: $viewModel.isNextToUserInfo){
                Text("다음으로")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        let otpCode = otpModel.otpFields.joined()
                        print(otpCode)
                        viewModel.otpCode = otpCode
                        print(viewModel.otpCode)
                        viewModel.checkCode()
                    }
            }
        }
        .padding(EdgeInsets(top:scaler.scaleHeight(32), leading: scaler.scaleWidth(24), bottom: scaler.scaleHeight(38), trailing: scaler.scaleWidth(24)))
        .customNavigationBar(
            leftView: { BackButton() }
            )
        .onChange(of: otpModel.otpFields) { newValue in
            OTPCondition(value: newValue)
        }
        .onAppear(perform : UIApplication.shared.hideKeyboard)
        .edgesIgnoringSafeArea(.bottom)
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
    func getTimeString(time: Double) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    func bgTimer() {
        let curTime = Date.now
        let diffTime = curTime.distance(to: startTime)
        let result = Double(diffTime.formatted())!
        remainingTime = 5*60 + result
        
        if remainingTime < 0 {
            remainingTime = 0
        }
    }
    
    // MARK: Custom OTP TextField
    @ViewBuilder
    func OTPField()->some View {
        HStack(spacing:scaler.scaleWidth(16) ) {
            ForEach(0..<6, id: \.self){ index in
                VStack(spacing:scaler.scaleHeight(8)) {
                    TextField("", text: $otpModel.otpFields[index])
                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(28)))
                        .foregroundColor(.greyScale2)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField, equals: activeStateForIndex(index: index))
                    
                    Rectangle()
                        .fill(activeField == activeStateForIndex(index: index) ? Color.primary3 : Color.greyScale9)
                        .frame(height: scaler.scaleHeight(2))
                }
                .frame(width: scaler.scaleWidth(34))
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
            AuthCodeView(viewModel: SignUpViewModel())
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
