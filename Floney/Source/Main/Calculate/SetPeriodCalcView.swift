//
//  SetPeriodCalcView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI



struct SetPeriodCalcView: View {
    @Binding var isShowingCalc : Bool
    @Binding var isShowingPeriod : Bool
    @State var isShowingContent = false
    @State var isShowingCalendar = false
    @ObservedObject var viewModel : CalculateViewModel
   
    @State var text = "기간을 설정해주세요."
    
    var pageCount = 2
    var pageCountAll = 4
    var nickname = "user1"
    
    var body: some View {
        ZStack{
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
                            
                            
                            Text("정산할 기간을")
                                .font(.pretendardFont(.bold, size: 22))
                                .foregroundColor(.greyScale1)
                                .padding(.top, 11)
                            Text("설정해주세요")
                                .font(.pretendardFont(.bold, size: 22))
                                .foregroundColor(.greyScale1)
                        }
                        Spacer()
                    }
                    HStack(spacing: 12) {
                        Image("icon_calendar")
                        Text("\(text)")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale7)
                        Spacer()
                    }.padding(20)
                        .background(Color.greyScale12)
                        .cornerRadius(8)
                        .onTapGesture {
                            self.isShowingCalendar = true
                        }
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
                HStack(spacing:0){
                    
                    Text("이전으로")
                        .padding()
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.greyScale2)
                        .onTapGesture {
                            self.isShowingPeriod = false
                        }
                    Text("다음으로")
                        .padding()
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(width: UIScreen.main.bounds.width * 2/3)
                        .background(Color.primary1)
                        .onTapGesture {
                            self.isShowingContent = true
                        }
                }
                
            }
            .fullScreenCover(isPresented: $isShowingContent)  {
                SetContentCalcView(isShowingCalc: $isShowingCalc, isShowingPeriod: $isShowingPeriod, isShowingContent: $isShowingContent, viewModel: viewModel)
            }
            if isShowingCalendar {
                CalendarBottomSheet(isShowing: $isShowingCalendar, viewModel: viewModel)
            }
        }
    }
}

struct SetPeriodCalcView_Previews: PreviewProvider {
    static var previews: some View {
        SetPeriodCalcView(isShowingCalc: .constant(true), isShowingPeriod: .constant(true), viewModel: CalculateViewModel())
    }
}
