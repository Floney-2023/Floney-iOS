//
//  HomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.background2
            VStack {
                HStack
                {
                    Image("logo_floney_home")
                    Spacer()
                    Image("icon_profile")
                }
                CalendarView()
            }
            .padding(20)
        }
        .edgesIgnoringSafeArea(.vertical)
        
    }
}

struct CalendarView: View {
    @State private var selectedDate = Date()
    
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        return calendar
    }
    
    // 일,월,화,수,목,금,토
    private var weekdays: [String] {
        let weekdays = calendar.shortWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1
        return Array(weekdays[firstWeekdayIndex..<weekdays.count] + weekdays[0..<firstWeekdayIndex])
    }
    
    // 달
    private var month: DateComponents {
        return calendar.dateComponents([.year, .month], from: selectedDate)
    }
    
    // 해당 달의 시작날
    private var monthStartDate: Date {
        return calendar.date(from: month)!
    }
    
    // 해당 달의 마지막날
    private var monthEndDate: Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStartDate)!
    }
    
    // 하루 하루 2차 배열
    private var weeks: [[Date]] {
        let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: monthStartDate))!
        let endDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: monthEndDate))!
        var weeks: [[Date]] = []
        var week: [Date] = []
        var date = startDate
        while date <= endDate {
            week.append(date)
            if calendar.isDate(date, equalTo: endDate, toGranularity: .weekOfYear) {
                weeks.append(week)
            }
            if calendar.component(.weekday, from: date) == calendar.firstWeekday {
                weeks.append(week)
                week = []
            }
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return weeks
    }
    
    var body: some View {
        VStack {
            Text("\(month.month!)")
                .font(.pretendardFont(.semiBold, size: 20))
            
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .frame(maxWidth: .infinity)
                }
            }
            
            
            ForEach(weeks, id: \.self) { week in
                HStack(spacing: 0) {
                    ForEach(week, id: \.self) { date in
                        Text(calendar.component(.day, from: date) == 1 ? "\(calendar.component(.month, from: date))/\(calendar.component(.day, from: date))" : "\(calendar.component(.day, from: date))")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(calendar.isDate(date, inSameDayAs: selectedDate) ? Color.primary1 : Color.clear)
                            .onTapGesture {
                                selectedDate = date
                            }
                    }
                }
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
