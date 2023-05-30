//
//  HomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//
import SwiftUI

struct HomeView: View {
    private let month = Date()
    @State var isOnSettingBook = false
    var body: some View {
        // ScrollView {
        ZStack {
            Color.background3
                .edgesIgnoringSafeArea(.all)
            VStack(spacing:37) {
                HStack
                {
                    Image("logo_floney_home")
                    Spacer()
                    NavigationLink(destination: SettingBookView(isOnSettingBook: $isOnSettingBook),isActive: $isOnSettingBook){
                        Image("icon_profile_book")
                            .onTapGesture {
                                self.isOnSettingBook = true
                            }
                    }
                }
                
                CustomCalendarView(month: month, selectedDate: month)
                
            }.padding(20)
            
            //  }
            
        }
    }
}
struct TotalView: View {
    var body: some View {
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
    
}

struct CustomCalendarView: View {
    @State var month: Date
    
    @State private var selectedView: Int = 1
    @State var isShowingMonthPicker = false
    @State var selectedDate: Date?
    @State private var pickerPosition = CGSize.zero
    
    let daysOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    let calendar = Calendar.current
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }()
    
    
    var body: some View {
        let year = String(describing: calendar.component(.year, from: month))
        let monthStr = String(describing: calendar.component(.month, from: month))
       
        VStack(alignment: .center, spacing: 8) {
            // 날짜 헤더
            HStack {
                Image("leftSide")
                Button(action: {
                    withAnimation {
                        self.isShowingMonthPicker.toggle()
                    }
                }) {
                    Text(selectedView == 1 ? "\(year).\(monthStr)" : "\(selectedDate!, formatter: dateFormatter)")
                        .font(.pretendardFont(.semiBold, size: 20))
                        .foregroundColor(.greyScale1)
                    
                }
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                let frame = geo.frame(in: .global)
                                self.pickerPosition = CGSize(width: frame.maxX, height: frame.maxY)
                            }
                    }
                )
                Image("rightSide")
                Spacer()
                HStack {
                    Button(action: {
                        selectedView = 1
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
                        selectedView = 2
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
            if selectedView == 1 {
                MonthCalendar(month: $month, isShowingMonthPicker: $isShowingMonthPicker, selectedDate: $selectedDate)
            } else if selectedView == 2 {
                DayLinesView(date: $month)
            }
        }
        
    }
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

struct MonthYearPicker: View {
    @Binding var date: Date
    
    var body: some View {
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let yearStr = String(describing: year)
        let monthRange = 1...12
        let yearRange = 1900...2100

        
        return VStack {
            HStack {
                Button(action: {
                    if year > yearRange.lowerBound {
                        date = Calendar.current.date(from: DateComponents(year: year - 1, month: month))!
                    }
                }) {
                    Image("icon_chevron_left")
                }
                
                /*
                Picker(selection: Binding(
                    get: { year },
                    set: {
                        date = Calendar.current.date(from: DateComponents(year: $0, month: month))!
                    }),
                       label: EmptyView()) {
                    ForEach(yearRange, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                       .labelsHidden()
                       .frame(width: 100)
                 */
                Spacer()
                Text(yearStr)
                    .foregroundColor(.white)
                    .font(.pretendardFont(.medium, size: 14))
                Spacer()
                Button(action: {
                    if year < yearRange.upperBound {
                        date = Calendar.current.date(from: DateComponents(year: year + 1, month: month))!
                    }
                }) {
                    Image("icon_chevron_right")
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.primary1)
           /*
            Picker(selection: Binding(
                get: { month },
                set: {
                    date = Calendar.current.date(from: DateComponents(year: year, month: $0))!
                }),
                   label: EmptyView()) {
                ForEach(monthRange, id: \.self) { month in
                    Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                    if (month % 4 == 0) {
                        Text("\n")
                    }
                }
            }*/
            ForEach(0..<3, id: \.self) { rowIndex in
                HStack {
                    ForEach(0..<4, id: \.self) { columnIndex in
                        Spacer()
                        Button {
                            date = Calendar.current.date(from: DateComponents(year: year, month: rowIndex*4 + columnIndex + 1))!
                        } label: {
                            Text("\(rowIndex*4 + columnIndex + 1)월")
                                .foregroundColor(month == (rowIndex*4 + columnIndex + 1) ? .greyScale1 : .greyScale7)
                                .font(.pretendardFont(.regular, size: 13))
                        }
                        Spacer()
                    }
                    
                    Text("\n")
                }
                
            }
            
        }
    }
    
}


struct MonthPicker: View {
    @Binding var month: Date
    
    var body: some View {
        let dateClosedRange: ClosedRange<Date> = {
            let calendar = Calendar.current
            let startComponents = DateComponents(year: 1900, month: 1, day: 1)
            let endComponents = DateComponents(year: 2100, month: 12, day: 31)
            return calendar.date(from:startComponents)!...calendar.date(from:endComponents)!
        }()
        
        return DatePicker("", selection: $month, in: dateClosedRange, displayedComponents: .date)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .frame(maxWidth: 400)
    }
}

struct MonthCalendar: View {
    @Binding var month: Date
 
    @Binding var isShowingMonthPicker : Bool
    @Binding var selectedDate: Date?
    @State private var pickerPosition = CGSize.zero
    
    let daysOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
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
                    //Text("Selected date: \(selectedDate, formatter: dateFormatter)")
                       // .padding(.top)
                }
                TotalView()
                
            }
            
            if isShowingMonthPicker {
                MonthYearPicker(date: $month)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .frame(width: 300, height: 200)
                    .offset(x: 0, y: 0)
                //.transition(.slide)
            }
        }
    }
    
    
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }()
    
   
}

struct DateCalendar: View {
    var body: some View {
        Text("This is View 1")
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
