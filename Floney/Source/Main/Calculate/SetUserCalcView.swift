//
//  SetUserCalcView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI

struct SetUserCalcView: View {
    @Binding var isShowingCalc : Bool
    @State var isShowingPeriod = false
    @StateObject var viewModel = CalculateViewModel()
    var pageCount = 1
    var pageCountAll = 4
    var nickname = "user1"
    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Image("icon_close")
                        .padding(.trailing, 24)
                        .onTapGesture {
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
                        
                        HStack(spacing: 15) {
                            Image("icon_profile")
                                .padding(.vertical,20)
                                .padding(.leading, 20)
                            
                            Text("\(nickname)")
                                .font(.pretendardFont(.semiBold, size: 14))
                                .foregroundColor(.greyScale2)
                            
                            Spacer()
                            Image("icon_check_circle")
                                .padding(20)
                        }
                        .background(Color.primary10)
                        .cornerRadius(12)
                        
                        HStack(spacing: 15) {
                            Image("icon_profile")
                                .padding(.vertical,20)
                                .padding(.leading, 20)
                            
                            Text("\(nickname)")
                                .font(.pretendardFont(.semiBold, size: 14))
                                .foregroundColor(.greyScale2)
                            
                            Spacer()
                            Image("icon_check_circle_disabled")
                                .padding(20)
                        }
                        .background(Color.greyScale12)
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
                
               
                    Text("다음으로")
                        .padding()
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.primary1)
                        .onTapGesture {
                            self.isShowingPeriod = true
                        }
            }
            .fullScreenCover(isPresented: $isShowingPeriod)  {
                SetPeriodCalcView(isShowingCalc: $isShowingCalc, isShowingPeriod: $isShowingPeriod, viewModel: viewModel)
                    
            }
    
    }
}

struct SetUserCalcView_Previews: PreviewProvider {
    static var previews: some View {
        SetUserCalcView(isShowingCalc: .constant(true))
    }
}
