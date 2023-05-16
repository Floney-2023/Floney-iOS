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
        ScrollView {
            ZStack {
                Color.background2
                VStack {
                    HStack
                    {
                        Image("logo_floney_home")
                        Spacer()
                        Image("icon_profile")
                    }
                    CustomCalendarView(month: month)
                }
                .padding(20)
            }
            .edgesIgnoringSafeArea(.vertical)
        }
        
    }
}

struct CustomCalendarView: View {
    let month: Date
    let calendar = Calendar.current
    let daysOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    @State var selectedDate: Date?
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            // 날짜 헤더
            Text("\(calendar.component(.year, from: month)).\(calendar.component(.month, from: month))")
                .font(.title)
            

            // 날짜 가져오기
            let dates = generateDates(for: month)
            
            
            let numberOfRows = dates.count / 7 + (dates.count % 7 == 0 ? 0 : 1)
            VStack {
                // 요일
                HStack {
                    ForEach(daysOfTheWeek, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                    }
                }
                ForEach(0..<numberOfRows, id: \.self) { rowIndex in
                    HStack {
                        ForEach(0..<7, id: \.self) { columnIndex in
                            if rowIndex * 7 + columnIndex < dates.count {
                                let date = dates[rowIndex * 7 + columnIndex]
                                let isToday = calendar.isDateInToday(date)
                                let isSelected = selectedDate == date
                                
                                Text("\(calendar.component(.day, from: date))")
                                    .frame(maxWidth: .infinity)
                                    //.padding(15)
                                    .background(isSelected ? Color.blue : (isToday ? Color.gray : Color.clear))
                                    .foregroundColor(isSelected ? .white : .primary)
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        selectedDate = date
                                    }
                            } else {
                                Spacer()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .background(Color.white)
            
            if let selectedDate = selectedDate {
                Text("Selected date: \(selectedDate, formatter: dateFormatter)")
                    .padding(.top)
            }
        }
        .padding()
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
