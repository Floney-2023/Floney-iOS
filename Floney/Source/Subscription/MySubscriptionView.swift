//
//  MySubscriptionView.swift
//  Floney
//
//  Created by 남경민 on 2023/09/13.
//

import SwiftUI

struct MySubscriptionView: View {
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
                        .padding(.trailing, 20)
                        .onTapGesture {
                            showingTabbar = true
                            isShowing = false
                        }
                    
                }
                Text("구독 정보")
                    .font(.pretendardFont(.semiBold, size: 16))
                    .foregroundColor(.greyScale1)
                
            }.padding(.top, 18)
            .padding(.bottom,38)
            
            
            VStack {
                HStack {
                    Text("floney plus+")
                        .font(.pretendardFont(.semiBold, size: 18))
                        .foregroundColor(.greyScale1)
                        
                    Spacer()
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 51, height: 24)
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
                            .font(.pretendardFont(.semiBold, size: 12))
                            .foregroundColor(.white)
                        
                    }
                }.padding(.horizontal, 20)
                    .padding(.top, 20)
                Spacer()
                
                HStack {
                    Text("\(viewModel.expiresDate) 갱신 예정")
                        .font(.pretendardFont(.regular, size: 12))
                        .foregroundColor(.greyScale5)
                    Spacer()
                    
                    Text("\(viewModel.formattedPrice)")
                        .font(.pretendardFont(.semiBold, size: 18))
                        .foregroundColor(.greyScale1)
                    + Text(" / 월")
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.greyScale3)
                    
                }.padding(.horizontal, 20)
                
                
            }
            .frame(height: UIScreen.main.bounds.height * 0.17)
            .padding(.bottom,20)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1)
                    
            )
            if viewModel.renewalStatus {
                Spacer()

                VStack {
                    Text("구독 해지")
                        .font(.pretendardFont(.regular, size: 12))
                        .foregroundColor(.greyScale6)
                    Divider()
                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                        .frame(width: 50,height: 1.0)
                        .foregroundColor(.greyScale6)
                    
                }
                .padding(.bottom, 38)
                .onTapGesture {
                    isShowingUnScribe = true
                    isShowing = false
                }
            } else {
                Button {
                    IAPManager.shared.buyProduct(productID)
                } label: {
                    Text("다시 시작하기")
                        .font(.pretendardFont(.semiBold, size: 13))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                }.frame(maxWidth: .infinity)
                    .background(Color.primary1)
                    .cornerRadius(12)
                Spacer()
                
            }

        }
        .padding(.horizontal, 20)
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
