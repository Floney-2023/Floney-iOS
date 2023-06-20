//
//  HomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = CalendarViewModel()
    @State var isOnSettingBook = false
    @State var isShowingMonthPicker = false
    @State var isShowingBottomSheet = false
    @State var isShowingAddView = false
    @State var selectedDate = ""
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
                
                //MARK: 캘린더 뷰
                CustomCalendarView(viewModel: viewModel, isShowingMonthPicker: $isShowingMonthPicker, isShowingBottomSheet: $isShowingBottomSheet)
                
            }.padding(20)
                
            
            if isShowingMonthPicker {
                Color.black
                    .opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowingMonthPicker.toggle()
                    }
                MonthYearPicker(viewModel : viewModel, date: $viewModel.selectedDate)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .frame(width: 300, height: 200)
                    .offset(x: -40, y: -150)
            }
            
            if isShowingBottomSheet {
                DayLinesBottomSheet(viewModel: viewModel, isShowing: $isShowingBottomSheet, isShowingAddView: $isShowingAddView)
            }
            
            
        }.fullScreenCover(isPresented: $isShowingAddView){
            AddView.init(date:viewModel.selectedDateStr)
        }
    }
}
//MARK: 총지출/총수입
struct TotalView: View {
    @ObservedObject var viewModel : CalendarViewModel
    var body: some View {
        HStack(spacing:23){
            VStack(alignment: .leading,spacing: 8){
                Text("총지출")
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(.white)
                Text("\(viewModel.totalOutcome)")
                    .font(.pretendardFont(.semiBold, size: 16))
                    .foregroundColor(.white)
            }
            .padding(20)
            
            VStack(alignment: .leading, spacing: 8){
                
                Text("총수입")
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(.white)
                Text("\(viewModel.totalIncome)")
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

//MARK: 캘린더 메인
struct CustomCalendarView: View {
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var isShowingMonthPicker : Bool
    @Binding var isShowingBottomSheet : Bool
  
    let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            // 날짜 헤더
            HStack {
                Image("leftSide")
                Button(action: {
                    withAnimation {
                        self.isShowingMonthPicker.toggle()
                    }
                }) {
                    Text(viewModel.selectedView == 1 ? "\(viewModel.selectedYearMonth)" : "\(viewModel.selectedMonth).\(viewModel.selectedDay)")
                        .font(.pretendardFont(.semiBold, size: 20))
                        .foregroundColor(.greyScale1)
                }
                
                Image("rightSide")
                Spacer()
                HStack {
                    Button(action: {
                        viewModel.selectedView = 1
                    }) {
                        Text("캘린더")
                            .font(.pretendardFont(.semiBold, size: 11))
                    }
                    //.frame(width: 54, height: 24)
                    .padding(10)
                    .background(viewModel.selectedView == 1 ? Color.white : Color.greyScale10)
                    .foregroundColor(viewModel.selectedView == 1 ? Color.greyScale2 : Color.greyScale8)
                    .cornerRadius(5)
                    
                    Button(action: {
                        viewModel.selectedView = 2
                    }) {
                        Text("일별")
                            .font(.pretendardFont(.semiBold, size: 11))
                    }
                    //.frame(width: 54, height: 24)
                    .padding(10)
                    .background(viewModel.selectedView == 2 ? Color.white : Color.greyScale10)
                    .foregroundColor(viewModel.selectedView == 2 ? Color.greyScale2 : Color.greyScale8)
                    .cornerRadius(5)
                }
                .background(Color.greyScale10)
                .frame(width: 116, height: 32)
                .cornerRadius(8)
                
            }
            if viewModel.selectedView == 1 {
                MonthCalendar(viewModel: viewModel, isShowingMonthPicker: $isShowingMonthPicker, isShowingBottomSheet: $isShowingBottomSheet)
            } else if viewModel.selectedView == 2 {
                DayLinesView(date: $viewModel.selectedDate, viewModel: viewModel)
            }
        }
        
    }
}
//MARK: 달 선택
struct MonthYearPicker: View {
    @ObservedObject var viewModel : CalendarViewModel
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
                        viewModel.calcDate(date)
                    }
                }) {
                    Image("icon_chevron_left")
                }
                
                Spacer()
                Text(yearStr)
                    .foregroundColor(.white)
                    .font(.pretendardFont(.medium, size: 14))
                Spacer()
                
                Button(action: {
                    if year < yearRange.upperBound {
                        date = Calendar.current.date(from: DateComponents(year: year + 1, month: month))!
                        viewModel.calcDate(date)
                    }
                }) {
                    Image("icon_chevron_right")
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Color.primary1)
            
            ForEach(0..<3, id: \.self) { rowIndex in
                HStack {
                    ForEach(0..<4, id: \.self) { columnIndex in
                        Spacer()
                        Button {
                            date = Calendar.current.date(from: DateComponents(year: year, month: rowIndex*4 + columnIndex + 1))!
                            viewModel.calcDate(date)
                            
                        } label: {
                            Text("\(rowIndex*4 + columnIndex + 1)월")
                                .padding(.vertical, 10)
                                .foregroundColor(month == (rowIndex*4 + columnIndex + 1) ? .greyScale1 : .greyScale7)
                                .font(.pretendardFont(.regular, size: 13))
                        }
                
                        Spacer()
                    }
                 
                }
                
            }
            
        }.frame(width: 278)
    }
    
}

//MARK: main 1
struct MonthCalendar: View {
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var isShowingMonthPicker : Bool
    @Binding var isShowingBottomSheet : Bool
    
    let calendar = Calendar.current
    
    var body: some View {
            VStack(spacing: 20) {
                // 날짜 가져오기
                let dates = viewModel.generateDates(for: viewModel.selectedDate)
                let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: viewModel.selectedDate))!
                let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)

                let numberOfRows = dates.count / 7 + (dates.count % 7 == 0 ? 0 : 1)
                VStack {
                    //MARK: 요일
                    HStack {
                        ForEach(viewModel.daysOfTheWeek, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.pretendardFont(.medium, size: 12))
                                .foregroundColor(.greyScale6)
                        }
                    }.padding(.top, 20)
                    
                    ForEach(0..<numberOfRows, id: \.self) { rowIndex in
                        HStack {
                            ForEach(0..<7, id: \.self) { columnIndex in
                              
                                if rowIndex * 7 + columnIndex < dates.count {
                                    let date = dates[rowIndex * 7 + columnIndex]
                                    let isSelected = viewModel.selectedDateStr == date
                                    let components = date.split(separator: "-")
                                    
                                    VStack {
                                        if let dayComponent = components.last {
                                            let day = String(dayComponent)
                                           
                                            if day == "0" {
                                                Text("")
                                                    .padding()
                                                    .font(.pretendardFont(.regular, size: 12))
                                                    .frame(maxWidth: .infinity)
                                                //.padding(15)
                                                    .background(isSelected ? .primary1 : (date == viewModel.totalToday ? Color.primary1 : Color.clear))
                                                    .foregroundColor(isSelected ? .white : .greyScale2)
                                                //.cornerRadius(20)
                                                    .clipShape(Circle())
                                                    .onTapGesture {
                                                        viewModel.selectedDateStr = date
                                                    }
                                            } else {
                                                Text("\(day)")
                                                    .padding(7)
                                                    .font(.pretendardFont(.regular, size: 12))
                                                    .frame(maxWidth: .infinity)
                                               
                                                    .background(isSelected ? .primary1 : (date == viewModel.totalToday ? Color.primary1 : Color.clear))
                                                    .foregroundColor(isSelected ? .white : (date == viewModel.totalToday ? .white : .greyScale2))
                                             
                                                    .clipShape(Circle())
                                                    .onTapGesture {
                                                        viewModel.selectedDateStr = date
                                                        viewModel.selectedDay = Int(dayComponent)!
                                                        isShowingBottomSheet.toggle()
                                                    }
                                                VStack {
                                                    ForEach(viewModel.expenses, id: \.self) { (expense: CalendarExpenses) in
                                                        let extractedDay = viewModel.extractDay(from: expense.date)
                                                        let assetType = expense.assetType
                                                        let money = expense.money
                                                        
                                                        if extractedDay == day && assetType == "OUTCOME" && money > 0 {
                                                            Text("-\(money)")
                                                                .font(Font.pretendardFont(.medium, size:9))
                                                                .foregroundColor(.calendarRed)
                                                        }
                                                        
                                                        if extractedDay == day && assetType == "INCOME" && money > 0 {
                                                            Text("+\(money)")
                                                                .font(Font.pretendardFont(.medium, size:9))
                                                                .foregroundColor(.blue1)
                                                        }
                                                    }
                                                }
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    .frame(height: 70)
                                    
                                    
                                } else {
                                    //Spacer()
                                        //.frame(maxWidth: .infinity)
                                    Text("")
                                        .padding()
                                        .font(.pretendardFont(.regular, size: 12))
                                        .frame(maxWidth: .infinity)
                                }
                                
                            }
                        }
                    }
                    Spacer()
                }
                .frame(maxHeight : .infinity)
                .background(Color.white)
                .cornerRadius(12)
               
                TotalView(viewModel: viewModel)

            }
            
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
