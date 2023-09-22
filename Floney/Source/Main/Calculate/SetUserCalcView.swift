//
//  SetUserCalcView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI



struct SetUserCalcView: View {
    @Binding var isShowingTabbar : Bool
    @Binding var isShowingCalc : Bool
    //@State var isShowingPeriod = false
    @ObservedObject var viewModel : CalculateViewModel
    @Binding var pageCount : Int
    var pageCountAll = 4
    var nickname = "user1"
    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Image("icon_close")
                        .padding(.trailing, 24)
                        .onTapGesture {
                            self.isShowingTabbar = true
                            self.isShowingCalc = false
                        }
                }
                VStack(spacing: 32) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(pageCount)")
                                .foregroundColor(.greyScale2)
                                .font(.pretendardFont(.medium, size: 12))
                            + Text(" / \(pageCountAll)")
                                .foregroundColor(.greyScale6)
                                .font(.pretendardFont(.medium, size: 12))
 
                            Text("정산에 참여할 멤버를")
                                .font(.pretendardFont(.bold, size: 22))
                                .foregroundColor(.greyScale1)
                                .padding(.top, 11)
                            Text("선택해주세요")
                                .font(.pretendardFont(.bold, size: 22))
                                .foregroundColor(.greyScale1)
                        }
                        Spacer()
                    }
                    
                    VStack(spacing: 10) {
                        ForEach(viewModel.bookUsers.indices, id: \.self) { index in
                            HStack(spacing: 15) {
                                Image("user_profile_32")
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                    .padding(.vertical,20)
                                    .padding(.leading, 20)
                                
                                
                                Text("\(viewModel.bookUsers[index].nickname)")
                                    .font(.pretendardFont(.semiBold, size: 14))
                                    .foregroundColor(.greyScale2)
                                
                                Spacer()
                                if let isSelected = viewModel.bookUsers[index].isSelected {
                                    if isSelected {
                                        Image("icon_check_circle_activated")
                                            .padding(20)
                                    } else {
                                        Image("icon_check_circle_disabled")
                                            .padding(20)
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
                .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
                
                
                Text("다음으로")
                    .padding(.bottom, 10)
                    .font(.pretendardFont(.bold, size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height:UIScreen.main.bounds.height * 0.085)
                    .background(Color.primary1)
                    .onTapGesture {
                        //pageCount = 2
                        viewModel.checkUser()
                        if viewModel.userList.isEmpty {
                            AlertManager.shared.update(showAlert: true, message: "멤버를 선택해주세요.", buttonType: .red)
                        } else {
                            pageCount = 2
                        }
                    }
                    //.frame(maxHeight: .infinity)
                    
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
