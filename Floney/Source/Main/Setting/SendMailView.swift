//
//  SendMailView.swift
//  Floney
//
//  Created by 남경민 on 2023/11/03.
//
import SwiftUI
import UIKit
import MessageUI

struct SendMailView: View {
    let scaler = Scaler.shared
    @Binding var showingTabbar : Bool
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false

    var body: some View {
        VStack(spacing:0) {
             HStack {
                 VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                     VStack(alignment: .leading, spacing: scaler.scaleHeight(5)) {
                         Text("궁금한 점은")
                         Text("언제든지 말해주세요 🤭")
                     }
                     .font(.pretendardFont(.bold, size:scaler.scaleWidth(24)))
                     .foregroundColor(.greyScale1)
                     VStack(alignment: .leading, spacing: scaler.scaleHeight(3)) {
                         Text("궁금한 점을 문의해 주시면")
                         Text("메일로 플로니가 답변해 드립니다.")
                             
                     }
                     .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                     .foregroundColor(.greyScale6)
                 }
                 Spacer()
             }
             .padding(.top, scaler.scaleHeight(30))
             .padding(.horizontal,scaler.scaleWidth(24))
             
             
             Rectangle()
                 .foregroundColor(.clear)
                 .frame(width:scaler.scaleWidth(360), height: scaler.scaleWidth(360))
                 .background(
                    Image("illust_mail")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:scaler.scaleWidth(360), height: scaler.scaleWidth(360))
                 )

            Spacer()
            Text("메일로 문의하기")
                .padding(.horizontal, scaler.scaleWidth(20))
                .withNextButtonFormmating(.primary1)
                .onTapGesture {
                    self.isShowingMailView = true
                }
                .disabled(!MFMailComposeViewController.canSendMail())
             
         }
       
        .padding(.bottom, scaler.scaleHeight(38))
        .customNavigationBar(
            leftView: { BackButton() }
        )
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $isShowingMailView) {
            MailView(isShowing: self.$isShowingMailView, result: self.$result)
                .onAppear {
                    if let mailResult = self.result {
                        switch mailResult {
                        case .success(let result):
                            switch result {
                            case .sent:
                                // 이메일이 성공적으로 보내졌을 때 처리
                                print("이메일이 성공적으로 보내졌습니다.")
                            case .saved, .cancelled:
                                // 이메일이 저장되었거나 사용자가 취소한 경우 처리
                                print("이메일이 저장되었거나 사용자가 취소했습니다.")
                            case .failed:
                                // 이메일 전송에 실패한 경우 처리
                                print("이메일 전송에 실패했습니다.")
                            @unknown default:
                                // 다른 미래의 케이스에 대비한 처리
                                break
                            }
                        case .failure(let error):
                            // 이메일 전송 중에 오류가 발생한 경우 처리
                            print("이메일 전송 중 오류가 발생했습니다: \(error.localizedDescription)")
                        }
                    }
                }
        }
        .onAppear {
            showingTabbar = false
        }

    }
    
}

struct MailView: UIViewControllerRepresentable {

    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        // 받는 사람의 이메일 주소 설정
        vc.setToRecipients(["floney.team@gmail.com"])

        // 기본 내용 설정
        let emailBody = "[사용자 정보]\n간편 로그인 유무 및 종류 :\n가입한 이메일 :\n가계부 이름 :\n\n안녕하세요, 궁금한 점을 문의드립니다."
        vc.setMessageBody(emailBody, isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
struct SendMailView_Previews: PreviewProvider {
    static var previews: some View {
        SendMailView(showingTabbar: .constant(false))
    }
}
