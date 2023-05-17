//
//  HomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//
import SwiftUI

struct HomeView: View {
    private let month = Date()
    var body: some View {
       // ScrollView {
            ZStack {
                Color.background2
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing:37) {
                    HStack
                    {
                        Image("logo_floney_home")
                        Spacer()
                        Image("icon_profile_book")
                    }
                    CustomCalendarView(month: month)
                    HStack(spacing:23){
                        VStack(alignment: .leading,spacing: 8){
                            Text("총지출")
                                .font(.pretendardFont(.medium, size: 12))
                                .foregroundColor(.white)
                            Text("100,000원")
                                .font(.pretendardFont(.semiBold, size: 16))
                                .foregroundColor(.white)
                        }
                        .padding(20)
                        
                        VStack(alignment: .leading, spacing: 8){
                            
                            Text("총수입")
                                .font(.pretendardFont(.medium, size: 12))
                                .foregroundColor(.white)
                            Text("100,000원")
                                .font(.pretendardFont(.semiBold, size: 16))
                                .foregroundColor(.white)
                        }
                        .padding(20)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.primary5)
                    .cornerRadius(12)
                    Spacer()
                }
                .padding(20)
                
                
            }
           
      //  }
      
    }
}

struct CustomCalendarView: View {
    let month: Date
    let calendar = Calendar.current
    @State private var selectedView: Int = 1
    
    let daysOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    @State var selectedDate: Date?
    
    var body: some View {
        let year = String(describing: calendar.component(.year, from: month))
        VStack(alignment: .center, spacing: 8) {
            // 날짜 헤더
            HStack {
                Image("leftSide")
                Text("\(year).\(calendar.component(.month, from: month))")
                    .font(.pretendardFont(.semiBold, size: 20))
                    .foregroundColor(.greyScale1)
                Image("rightSide")
                Spacer()
                HStack {
                    Button(action: {
                        //selectedView = 1
                    }) {
                        Text("캘린더")
                            .font(.pretendardFont(.semiBold, size: 11))
                    }
                    //.frame(width: 54, height: 24)
                    .padding(10)
                    .background(selectedView == 1 ? Color.white : Color.greyScale10)
                    .foregroundColor(selectedView == 1 ? Color.greyScale2 : Color.greyScale8)
                    .cornerRadius(5)
                    
                    Button(action: {
                        //     selectedView = 2
                    }) {
                        Text("일별")
                            .font(.pretendardFont(.semiBold, size: 11))
                    }
                    //.frame(width: 54, height: 24)
                    .padding(10)
                    .background(selectedView == 2 ? Color.white : Color.greyScale10)
                    .foregroundColor(selectedView == 2 ? Color.greyScale2 : Color.greyScale8)
                    .cornerRadius(5)
                }
                .background(Color.greyScale10)
                .frame(width: 116, height: 32)
                .cornerRadius(8)
                
            }
            

            // 날짜 가져오기
            let dates = generateDates(for: month)
            
            
            let numberOfRows = dates.count / 7 + (dates.count % 7 == 0 ? 0 : 1)
            VStack {
                // 요일
                HStack {
                    ForEach(daysOfTheWeek, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(.pretendardFont(.medium, size: 12))
                            .foregroundColor(.greyScale6)
                    }
                }
                
                ForEach(0..<numberOfRows, id: \.self) { rowIndex in
                    HStack {
                        ForEach(0..<7, id: \.self) { columnIndex in
                            if rowIndex * 7 + columnIndex < dates.count {
                                let date = dates[rowIndex * 7 + columnIndex]
                                let isToday = calendar.isDateInToday(date)
                                let isSelected = selectedDate == date
                                
                                VStack {
                                    Text("\(calendar.component(.day, from: date))")
                                        .font(.pretendardFont(.regular, size: 12))
                                        .frame(maxWidth: .infinity)
                                    //.padding(15)
                                        .background(isSelected ? .primary1 : (isToday ? Color.primary1 : Color.clear))
                                        .foregroundColor(isSelected ? .white : .greyScale2)
                                        .cornerRadius(20)
                                        .onTapGesture {
                                            selectedDate = date
                                        }
                                    
                                    Text("-30,000")
                                        .font(Font.pretendardFont(.medium, size:9))
                                        .foregroundColor(.calendarRed)
                                    Text("+30,000")
                                        .font(Font.pretendardFont(.medium, size:9))
                                        .foregroundColor(.blue1)
                                }
                                .frame(height: 50)
                                                    
                                
                            } else {
                                Spacer()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .frame(height:362)
            .background(Color.white)
            .cornerRadius(12)
            
            if let selectedDate = selectedDate {
                Text("Selected date: \(selectedDate, formatter: dateFormatter)")
                    .padding(.top)
            }
        }
     
    }
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

// MARK: 해당 달에 대한 date 반환
func generateDates(for month: Date, using calendar: Calendar = .current) -> [Date] {
    var dates: [Date] = []
    
    if let monthRange = calendar.range(of: .day, in: .month, for: month) {
        let components = calendar.dateComponents([.year, .month], from: month)
        
        for day in monthRange {
            var dateComponents = components
            dateComponents.day = day
            if let date = calendar.date(from: dateComponents) {
                dates.append(date)
            }
        }
    }
    
    return dates
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
