//
//  SetPeriodCalcView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI



struct SetPeriodCalcView: View {
    @Binding var isShowingTabbar : Bool
    @Binding var isShowingCalc : Bool
    //@Binding var isShowingPeriod : Bool
    //@State var isShowingContent = false
    @State var isShowingCalendar = false
    @ObservedObject var viewModel : CalculateViewModel
   
    @State var text = "기간을 설정해주세요."
    
    @Binding var pageCount : Int
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
                        if viewModel.selectedDates.count == 2 {
                            if viewModel.startDateStr == viewModel.endDateStr {
                                Text("\(viewModel.selectedStartDateStr)")
                                .font(.pretendardFont(.medium, size: 16))
                                .foregroundColor(.greyScale2)
                            } else  {
                                Text("\(viewModel.selectedDatesStr)")
                                .font(.pretendardFont(.medium, size: 16))
                                .foregroundColor(.greyScale2)
                                }
                        } else {
                            Text("\(text)")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale7)
                        }
                        
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
                        .padding(.bottom,10)
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .background(Color.greyScale2)
                        .onTapGesture {
                            pageCount = 1
                        }
                    Text("다음으로")
                        .padding(.bottom,10)
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(width: UIScreen.main.bounds.width * 2/3)
                        .frame(maxHeight: .infinity)
                        .background(Color.primary1)
                        .onTapGesture {
                            if viewModel.selectedDates.count == 2 {
                                viewModel.getSettlements()
                                pageCount = 3
                            } else {
                                AlertManager.shared.update(showAlert: true, message: "기간을 설정해주세요.", buttonType: .red)
                            }
                        }
                }
                .frame(height:UIScreen.main.bounds.height * 0.084)
                
            }
            .edgesIgnoringSafeArea(.bottom)
          
            if isShowingCalendar {
                CalendarBottomSheet(isShowing: $isShowingCalendar, showingTab: $isShowingTabbar, viewModel: viewModel)
            }
        }
    }
}

struct SetPeriodCalcView_Previews: PreviewProvider {
    static var previews: some View {
        SetPeriodCalcView(isShowingTabbar: .constant(false), isShowingCalc: .constant(true), viewModel: CalculateViewModel(), pageCount: .constant(2))
    }
}
