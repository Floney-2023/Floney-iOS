//
//  SetUserCalcView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI
import Kingfisher

struct SetUserCalcView: View {
    let scaler = Scaler.shared
    @Binding var isShowingTabbar : Bool
    @Binding var isShowingCalc : Bool
    @ObservedObject var viewModel : CalculateViewModel
    @Binding var pageCount : Int
    var pageCountAll = 4
    var nickname = "user1"
    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Image("icon_close")
                        .padding(.trailing,scaler.scaleWidth(20))
                        .padding(.top,scaler.scaleHeight(22))
                        .onTapGesture {
                            self.isShowingTabbar = true
                            self.isShowingCalc = false
                        }
                }
                VStack(spacing: scaler.scaleHeight(24)) {
                    HStack {
                        VStack(alignment: .leading, spacing: scaler.scaleHeight(5)) {
                            Text("\(pageCount)")
                                .foregroundColor(.greyScale2)
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                            + Text(" / \(pageCountAll)")
                                .foregroundColor(.greyScale6)
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
 
                            Text("정산에 참여할 멤버를")
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(22)))
                                .foregroundColor(.greyScale1)
                                .padding(.top, scaler.scaleHeight(11))
                            Text("선택해주세요")
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(22)))
                                .foregroundColor(.greyScale1)
                        }
                        Spacer()
                    }
                    .padding(.leading, scaler.scaleWidth(4))
                    
                    VStack(spacing: scaler.scaleHeight(12)) {
                        ForEach(viewModel.bookUsers.indices, id: \.self) { index in
                            HStack(spacing:scaler.scaleWidth(12)) {
                                if viewModel.bookUsers[index].profileImg == "user_default" {
                                    Image("user_profile_32")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        .padding(.vertical,scaler.scaleWidth(20))
                                        .padding(.leading, scaler.scaleWidth(20))
                                    
                                } else if viewModel.bookUsers[index].profileImg.hasPrefix("random"){
                                    let components = viewModel.bookUsers[index].profileImg.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                    let random = components.first!  // "random"
                                    let number = components.last!   // "5"
                                    Image("img_user_random_profile_0\(number)_32")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        .padding(.vertical,scaler.scaleWidth(20))
                                        .padding(.leading, scaler.scaleWidth(20))
                                }
                                else {
                                    let url = URL(string : viewModel.bookUsers[index].profileImg)
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
                                        .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        .padding(.vertical,scaler.scaleWidth(20))
                                        .padding(.leading, scaler.scaleWidth(20))
                                        
                                }

                                Text("\(viewModel.bookUsers[index].nickname)")
                                    .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale2)
                                
                                Spacer()
                                if let isSelected = viewModel.bookUsers[index].isSelected {
                                    if isSelected {
                                        Image("icon_check_circle_activated")
                                            .padding(.trailing, scaler.scaleWidth(20))
                                    } else {
                                        Image("icon_check_circle_disabled")
                                            .padding(.trailing, scaler.scaleWidth(20))
                                    }
                                }
                            }
                            .background(Color.primary10)
                            .cornerRadius(12)
                            .onTapGesture {
                                viewModel.bookUsers[index].isSelected?.toggle()
                            }
                        }
                    }

                    Spacer()
                }
                .padding(EdgeInsets(top:scaler.scaleHeight(22), leading: scaler.scaleWidth(20), bottom: 0, trailing: scaler.scaleWidth(20)))
                
                
                Text("다음으로")
                    .padding(.bottom,scaler.scaleHeight(10))
                    .font(.pretendardFont(.bold, size:scaler.scaleWidth(14)))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:scaler.scaleHeight(66))
                    .background(Color.primary1)
                    .frame(height:scaler.scaleHeight(66))
                    .onTapGesture {
                        viewModel.checkUser()
                        if viewModel.userList.isEmpty {
                            AlertManager.shared.update(showAlert: true, message: "멤버를 선택해주세요.", buttonType: .red)
                        } else {
                            pageCount = 2
                        }
                    }
                    
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{
                viewModel.getBookUsers()
                isShowingTabbar = false
            }
    
    }
}

struct SetUserCalcView_Previews: PreviewProvider {
    static var previews: some View {
        SetUserCalcView(isShowingTabbar: .constant(true), isShowingCalc: .constant(false), viewModel: CalculateViewModel(), pageCount: .constant(1))
    }
}
