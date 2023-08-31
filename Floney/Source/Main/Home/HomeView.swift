//
//  HomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//
import SwiftUI

struct HomeView: View {
    @StateObject var alertManager = AlertManager.shared
    @StateObject var viewModel = CalendarViewModel()
    var encryptionManager = CryptManager()
    var profileManager = ProfileManager.shared
    @Binding var showingTabbar : Bool
    @State var isOnSettingBook = false
    @State var isShowingMonthPicker = false
    @State var isShowingBottomSheet = false
    @State var isShowingAddView = false
    var lineModel = LineModel()
    
    var body: some View {
        // ScrollView {
        ZStack {
            Color.background3
                .edgesIgnoringSafeArea(.all)
            VStack(spacing:37) {
                //MARK: 로고, 프로필 이미지
                HStack
                {
                    Image("logo_floney_home")
                    Spacer()
                    NavigationLink(destination: SettingBookView(showingTabbar: $showingTabbar, isOnSettingBook: $isOnSettingBook),isActive: $isOnSettingBook){
                        if let bookUrl = viewModel.bookProfileImage {
                            let url = encryptionManager.decrypt(bookUrl, using: encryptionManager.key!)
                            URLImage(url: URL(string: url!)!)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 34, height: 34)
                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                .onTapGesture {
                                    self.showingTabbar = false
                                    self.isOnSettingBook = true
                                }
                        } else {
                            Image("book_profile_34")
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                .onTapGesture {
                                    self.showingTabbar = false
                                    self.isOnSettingBook = true
                                }
                        }
                    }
                }
                ScrollView(showsIndicators: false)
                {
                    // MARK: 캘린더 뷰 - viewModel로 상태 추적
                    CustomCalendarView(viewModel: viewModel, isShowingMonthPicker: $isShowingMonthPicker, isShowingBottomSheet: $isShowingBottomSheet,isShowingAddView: $isShowingAddView)
                }
                
            }.padding(20)
                .overlay(
                    ZStack {
                        if alertManager.showAlert {
                            CustomAlertView(message: alertManager.message, type: alertManager.buttontType, isPresented: $alertManager.showAlert)
                        }
                    }
                )
            
            // MARK: Month Year Picker
            if isShowingMonthPicker {
                MonthYearPickerBottomSheet(viewModel: viewModel, availableChangeTabbarStatus: true, showingTab: $showingTabbar, isShowing: $isShowingMonthPicker)
            }
            
            if isShowingBottomSheet {
                DayLinesBottomSheet(viewModel: viewModel, isShowing: $isShowingBottomSheet, isShowingAddView: $isShowingAddView)
            }
            
        }.fullScreenCover(isPresented: $isShowingAddView) {
            NavigationView {
                
                AddView.init(isPresented: $isShowingAddView, lineModel: lineModel, date: viewModel.selectedDateStr)
            }
        }
        .onAppear {
            self.showingTabbar = true
        }
    }
}
//MARK: 총지출/총수입
struct TotalView: View {
    @ObservedObject var viewModel : CalendarViewModel
    
    var body: some View {
        HStack(){
            HStack {
                VStack(alignment: .leading, spacing: 8){
                    Text("총지출")
                        .font(.pretendardFont(.medium, size: 12))
                        .foregroundColor(.white)
                    
                    Text("\(viewModel.totalOutcome)원")
                        .font(.pretendardFont(.semiBold, size: 16))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            
            HStack {
                VStack(alignment: .leading, spacing: 8){
                    
                    Text("총수입")
                        .font(.pretendardFont(.medium, size: 12))
                        .foregroundColor(.white)
                    Text("\(viewModel.totalIncome)원")
                        .font(.pretendardFont(.semiBold, size: 16))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity)
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
    @Binding var isShowingAddView : Bool
  
    let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            // MARK: 날짜 헤더
            HStack {
                Image("leftSide")
                
                Button(action: {
                    withAnimation {
                        if viewModel.selectedView == 0 {
                            self.isShowingMonthPicker.toggle() // MARK: 연도, 월 변경 toggle
                        }
                    }
                }) {
                    Text(viewModel.selectedView == 0 ? "\(viewModel.selectedYearMonth)" : "\(viewModel.selectedMonth).\(viewModel.selectedDay)")
                        .font(.pretendardFont(.semiBold, size: 20))
                        .foregroundColor(.greyScale1)
                }
                
                Image("rightSide")
                Spacer()
                //MARK: 캘린더, 일별 toggle
                HStack(spacing: 0) {
                    ForEach(viewModel.options.indices, id:\.self) { index in
                        ZStack {
                            Rectangle()
                                .fill(Color.greyScale10)
                            
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(5)
                                .padding(4)
                                .opacity(viewModel.selectedView == index ? 1 : 0.01)
                                .onTapGesture {
                                    withAnimation(.interactiveSpring()) {
                                        viewModel.selectedView = index
                                    }
                                }
                        }
                        .overlay(
                            Text(viewModel.options[index])
                                .font(.pretendardFont(.semiBold, size: 11))
                                .foregroundColor(viewModel.selectedView == index ? .greyScale2: .greyScale8)
                        )
                    }
                }
                
                .frame(width: 113)
                .frame(height: 38)
                .cornerRadius(8)
                                
            }
            if viewModel.selectedView == 0 {
                MonthCalendar(viewModel: viewModel, isShowingMonthPicker: $isShowingMonthPicker, isShowingBottomSheet: $isShowingBottomSheet)
            } else if viewModel.selectedView == 1 {
                DayLinesView(date: $viewModel.dayLinesDate, isShowingAddView: $isShowingAddView, viewModel: viewModel)
            }
        }
        
    }
}
//MARK: 피커 bottom sheet
struct MonthYearPickerBottomSheet: View {
    @ObservedObject var viewModel : CalendarViewModel
    @State var availableChangeTabbarStatus = false
    @Binding var showingTab : Bool
    @Binding var isShowing : Bool
    let years = Array(2000...2099)
    let months = Array(1...12)

    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                        if availableChangeTabbarStatus {
                            showingTab = true
                        }
                    }
                VStack {
                    HStack {
                        Spacer()
                        Button("완료") {
                            isShowing = false
                            if availableChangeTabbarStatus {
                                showingTab = true
                            }
                            viewModel.selectedDate = Date.from(year: viewModel.yearMonth.year, month: viewModel.yearMonth.month)
                            print("바뀐 selectedDate: \(viewModel.selectedDate)")
                            viewModel.calcDate(viewModel.selectedDate)
                        }
                        .font(.pretendardFont(.semiBold, size: 16))
                        .foregroundColor(.greyScale2)
                        .padding()
                    }
                    YearMonthPicker(selection: $viewModel.yearMonth, years: years, months: months)
                    // yearMonth가 바뀔 때마다 selectedDate가 바뀜
                }
                .frame(alignment: .bottom)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height / 3)
                .background(Color.greyScale12)
                .transition(.move(edge: .bottom))
                .cornerRadius(12, corners: [.allCorners])
                .onAppear {
                    showingTab = false
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
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
                // MARK: 날짜 가져오기
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
                                            let day = String(dayComponent) // 01, 02, ..., 31
                                            if day == "0" {
                                                Text("")
                                                    .padding()
                                                    .font(.pretendardFont(.regular, size: 12))
                                                    .frame(maxWidth: .infinity)
                                                    .background(isSelected ? .primary1 : (date == viewModel.totalToday ? Color.primary1 : Color.clear))
                                                    .foregroundColor(isSelected ? .white : .greyScale2)
                                                    .clipShape(Circle())
                                            } else {
                                                Text("\(Int(day)!)") // 1,2,...,31
                                                    .padding(7)
                                                    .font(.pretendardFont(.regular, size: 12))
                                                    .frame(maxWidth: .infinity)
                                                    .background(isSelected ? .primary1 : (date == viewModel.totalToday ? Color.primary1 : Color.clear))
                                                    .foregroundColor(isSelected ? .white : (date == viewModel.totalToday ? .white : .greyScale2))
                                                    .clipShape(Circle())
                                                    .onTapGesture { // 해당 날짜 터치할 경우
                                                        viewModel.selectedDateStr = date // 0000-00-00
                                                        viewModel.selectedDay = Int(dayComponent)!
                                                        viewModel.selectedDate = Calendar.current.date(from: DateComponents(year: viewModel.selectedYear, month: viewModel.selectedMonth , day: Int(dayComponent)))!

                                                        print("selected :\(viewModel.selectedDay)")
                                                        isShowingBottomSheet.toggle()
                                                    }
                                                VStack {
                                                    ForEach(viewModel.expenses, id: \.self) { (expense: CalendarExpenses) in
                                                        if viewModel.extractYearMonth(from: viewModel.selectedDateStr) {
                                                            let extractedDay = viewModel.extractDay(from: expense.date)
                                                            let assetType = expense.assetType
                                                            let money = expense.money
                                                            
                                                            if extractedDay == day && assetType == "OUTCOME" && money > 0 {
                                                                Text("-\(money)")
                                                                    .font(money < 1000000 ? Font.pretendardFont(.medium, size:9) : Font.pretendardFont(.medium, size:8))
                                                                    .foregroundColor(.calendarRed)
                                                            }
                                                            if extractedDay == day && assetType == "OUTCOME" && money == 0 {
                                                                Text("")
                                                                    .font(Font.pretendardFont(.medium, size:9))
                                                            }
                                                            
                                                            if extractedDay == day && assetType == "INCOME" && money > 0 {
                                                                Text("+\(money)")
                                                                    .font(money < 1000000 ? Font.pretendardFont(.medium, size:9) : Font.pretendardFont(.medium, size:8))
                                                                    .foregroundColor(.blue1)
                                                            }
                                                            if extractedDay == day && assetType == "INCOME" && money == 0 {
                                                                Text("")
                                                                    .font(Font.pretendardFont(.medium, size:9))
                                                                    
                                                            }
                                                        }
                                                    }
                                                }
                                                Spacer()
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    //.frame(height: 60)
                                    .frame(maxHeight: .infinity)
                                    //.background(Color.yellow2)
                                    
                                    
                                } else {
                                    Text("")
                                        .padding()
                                        .font(.pretendardFont(.regular, size: 12))
                                        .frame(maxWidth: .infinity)
                                }
                                
                            }
                            
                        }
                        .frame(maxHeight: .infinity)
                    }
                    Spacer()
                }
                .frame(maxHeight : .infinity)
                .background(Color.white)
                .cornerRadius(12)
                .onAppear {
                    viewModel.getCalendar()
                    viewModel.getBookInfo()
                }
                .onChange(of: viewModel.selectedYear) { newValue in
                    viewModel.getCalendar()
                }
                .onChange(of: viewModel.selectedMonth) { newValue in
                    viewModel.getCalendar()
                }
                TotalView(viewModel: viewModel)

            }
            .frame(maxHeight : .infinity)
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        //HomeView(showingTabbar: .constant(true))
        TotalView(viewModel: CalendarViewModel())
    }
}

/*
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
    .offset(x: -40, y: -150)*/


/*
//MARK: 달 선택
struct MonthYearPicker: View {
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var date: Date // 바뀐 날짜 업데이트
    
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
    
}*/
