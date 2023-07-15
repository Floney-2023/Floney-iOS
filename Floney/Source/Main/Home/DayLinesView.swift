//
//  CalendarView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/13.
//

import SwiftUI

struct DayLinesView: View {
    @Binding var date: String
    @Binding var isShowingAddView : Bool
    @ObservedObject var viewModel : CalendarViewModel
    var body: some View {
            VStack {
                DayTotalView(viewModel: viewModel)
                DayLinesDetailView(viewModel: viewModel, isShowingAddView: $isShowingAddView)
                Spacer()
            }//.padding(20)
            .background(Color.clear)
            .onAppear{
                print("date : \(date)")
                viewModel.getDayLines()
            }
    }
}

struct DayTotalView : View {
    @ObservedObject var viewModel : CalendarViewModel
    @State var totalIncome = 0
    @State var totalOutcome = 0
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 8) {
                Text("수입")
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(.greyScale12)
                
                Text("\(viewModel.dayLinesTotalIncome)")
                    .font(.pretendardFont(.semiBold, size: 18))
                    .foregroundColor(.white)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 8) {
                Text("지출")
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(.greyScale12)
                Text("\(viewModel.dayLinesTotalOutcome)")
                    .font(.pretendardFont(.semiBold, size: 18))
                    .foregroundColor(.white)
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(Color.primary5)
        .cornerRadius(12)
    }
}
struct DayLinesDetailView : View {
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var isShowingAddView : Bool
    var body: some View {
        VStack(spacing:88) {
            HStack {
                Text("내역")
                    .font(.pretendardFont(.bold, size: 16))
                    .foregroundColor(.greyScale1)
                Spacer()
                Text("내역 추가")
                    .font(.pretendardFont(.semiBold, size: 12))
                    .foregroundColor(.primary2)
                    .onTapGesture {
                        isShowingAddView = true
                    }
            }
            VStack {
                ScrollView {
                    if viewModel.dayLines.count == 0 {
                        Image("no_line")
                        Text("내역이 없습니다.")
                            .font(.pretendardFont(.medium, size: 12))
                            .foregroundColor(.greyScale6)
                    } else {
                        ForEach(viewModel.dayLines, id: \.self) { line in
                            HStack {
                                if viewModel.seeProfileImg {
                                    Image("icon_profile")
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                        
                                        Text("\(line!.content)")
                                            .font(.pretendardFont(.semiBold, size: 14))
                                            .foregroundColor(.greyScale2)
                                        HStack {
                                            ForEach(line!.category, id: \.self) { category in
                                                Text("\(category)‧")
                                                    .font(.pretendardFont(.medium, size: 12))
                                                    .foregroundColor(.greyScale6)
                                            }
                                            
                                        }
                                    }
                                    
                                Spacer()
                                if line!.assetType == "INCOME" {
                                    Text("+\(line!.money)")
                                        .font(.pretendardFont(.semiBold, size: 16))
                                        .foregroundColor(.greyScale2)
                                } else if line!.assetType == "OUTCOME" {
                                    Text("-\(line!.money)")
                                        .font(.pretendardFont(.semiBold, size: 16))
                                        .foregroundColor(.greyScale2)
                                    
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .frame(height: 366)
        .padding(20)
        .background(Color.white)
        .cornerRadius(12)
        
    }
}

struct DateCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DayLinesView(date : .constant("2023-06-20"), isShowingAddView: .constant(false), viewModel: CalendarViewModel())
    }
}
