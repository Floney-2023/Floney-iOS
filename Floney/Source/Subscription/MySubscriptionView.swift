//
//  MySubscriptionView.swift
//  Floney
//
//  Created by 남경민 on 2023/09/13.
//

import SwiftUI

struct MySubscriptionView: View {
    let scaler = Scaler.shared
    @Binding var showingTabbar : Bool
    @Binding var isShowing : Bool
    @Binding var isShowingUnScribe : Bool
    @StateObject var viewModel = SubscriptionViewModel()
    @State var productID = IAPProducts.FloneyPlusMonthly.rawValue
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Image("icon_close")
                        .onTapGesture {
                            showingTabbar = true
                            isShowing = false
                        }
                    
                }
                Text("구독 정보")
                    .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(16)))
                    .foregroundColor(.greyScale1)
                
            }.padding(.top,scaler.scaleHeight(18))
            .padding(.bottom,scaler.scaleHeight(38))
            
            
            VStack {
                HStack {
                    Text("floney plus+")
                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(18)))
                        .foregroundColor(.greyScale1)
                        
                    Spacer()
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: scaler.scaleWidth(51), height:scaler.scaleHeight(24))
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.19, green: 0.78, blue: 0.56), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.56, green: 0.88, blue: 0.76), location: 1.00),
                                        Gradient.Stop(color: Color(red: 0.5, green: 0.86, blue: 0.73), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 1, y: 1),
                                    endPoint: UnitPoint(x: 0, y: 0)
                                )
                            )
                            .cornerRadius(50)
                        
                        Text("D - \(viewModel.remainingPeriod)")
                            .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(12)))
                            .foregroundColor(.white)
                        
                    }
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.top,scaler.scaleHeight(20))
                Spacer()
                
                HStack {
                    Text("\(viewModel.expiresDate) 갱신 예정")
                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                        .foregroundColor(.greyScale5)
                    Spacer()
                    
                    Text("\(viewModel.formattedPrice)")
                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(18)))
                        .foregroundColor(.greyScale1)
                    + Text(" / 월")
                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale3)
                    
                }.padding(.horizontal, scaler.scaleWidth(20))
                
                
            }
            .frame(height: UIScreen.main.bounds.height * 0.17)
            .padding(.bottom,scaler.scaleHeight(20))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1)
                    
            )
            if viewModel.renewalStatus {
                Spacer()

                VStack(spacing:0) {
                    Text("구독 해지하기")
                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                        .foregroundColor(.greyScale6)
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: scaler.scaleWidth(66), height: scaler.scaleWidth(0.5))
                      .background(Color.greyScale6)
                    
                }
                .padding(.bottom, scaler.scaleHeight(38))
                .onTapGesture {
                    isShowingUnScribe = true
                    isShowing = false
                }
            } else {
                Button {
                    IAPManager.shared.buyProduct(productID)
                } label: {
                    Text("다시 시작하기")
                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(13)))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                }.frame(maxWidth: .infinity)
                    .background(Color.primary1)
                    .cornerRadius(12)
                Spacer()
                
            }

        }
        .padding(.horizontal, scaler.scaleWidth(20))
        .onAppear{
            viewModel.getSubscriptionInfo()
        }
    }
        

}

struct MySubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        MySubscriptionView(showingTabbar: .constant(false), isShowing: .constant(true), isShowingUnScribe: .constant(false))
    }
}
