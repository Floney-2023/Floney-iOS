//
//  HomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//
import SwiftUI
import Kingfisher
struct HomeView: View {
    private let adCoordinator = AdCoordinator(pageType: "HOME")
    private let rewardedAdCoordinator = RewardedAdCoordinator()
    @Environment(\.scenePhase) private var scenePhase
    var bookService = BookExistenceViewModel.shared
    let scaler = Scaler.shared
    @StateObject var alertManager = AlertManager.shared
    @StateObject var viewModel = CalendarViewModel()
    var profileManager = ProfileManager.shared
    @Binding var showingTabbar : Bool
    @Binding var mainAddViewStatus : Bool
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
            VStack(spacing: scaler.scaleHeight(26)) {
                //MARK: 로고, 프로필 이미지
                HStack
                {
                    Image("logo_floney_home")
                        .resizable()
                        .frame(width: scaler.scaleWidth(82), height: scaler.scaleHeight(19))
                        .padding(.top, scaler.scaleHeight(24))
                    Spacer()
                    NavigationLink(destination: SettingBookView(showingTabbar: $showingTabbar, isOnSettingBook: $isOnSettingBook),isActive: $isOnSettingBook){
                        HStack(alignment: .center, spacing:4) {
                            HStack(spacing:-2) {
                                Text(viewModel.bookInfoResult.bookName)
                                    .foregroundColor(.white)
                                    .font(.pretendardFont(.semiBold, size: 11))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 6)
                                    .background(Color.primary4)
                                    .cornerRadius(4)
                                Image("img_polygon")
                            }
                            .padding(.top, scaler.scaleHeight(18))
                            if let bookUrl = viewModel.bookProfileImage {
                                let url = URL(string : bookUrl)
                                KFImage(url)
                                    .placeholder { //플레이스 홀더 설정
                                        Image("book_profile_34")
                                    }.retry(maxCount: 3, interval: .seconds(5)) //재시도
                                    .onSuccess { success in //성공
                                        print("succes: \(success)")
                                    }
                                    .onFailure { error in //실패
                                        print("failure: \(error)")
                                    }
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: scaler.scaleWidth(34), height: scaler.scaleWidth(34))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                    .padding(.top, scaler.scaleHeight(16))
                            } else {
                                Image("book_profile_34")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: scaler.scaleWidth(34), height: scaler.scaleWidth(34))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                    .padding(.top, scaler.scaleHeight(16))
                                
                            }
                        }
                        .onTapGesture {
                            
                            if rewardedAdCoordinator.canShowAd() && adCoordinator.canShowHomeAd() {
                                adCoordinator.showAd()
                                adCoordinator.onAdDismiss = {
                                    self.showingTabbar = false
                                    self.isOnSettingBook = true
                                }
                            }
                            else {
                                self.showingTabbar = false
                                self.isOnSettingBook = true
                            }

                        }
                    }
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                
                CustomCalendarView(viewModel: viewModel, isShowingMonthPicker: $isShowingMonthPicker, isShowingBottomSheet: $isShowingBottomSheet,isShowingAddView: $isShowingAddView)
            }
            
            if rewardedAdCoordinator.canShowAd() {
                VStack{
                    Spacer()
                    GADBanner()
                        .frame(width: UIScreen.main.bounds.width, height: 50, alignment: .center)
                        .frame(minWidth: UIScreen.main.bounds.width)
                        .padding(.bottom, scaler.scaleHeight(76))
                    
                }
                .background(Color.clear)
                .ignoresSafeArea()
            }
        
            // MARK: Month Year Picker
            if isShowingMonthPicker {
                MonthYearPickerBottomSheet(viewModel: viewModel, availableChangeTabbarStatus: true, showingTab: $showingTabbar, isShowing: $isShowingMonthPicker)
            }
            
            if isShowingBottomSheet {
                DayLinesBottomSheet(viewModel: viewModel, isShowing: $isShowingBottomSheet, isShowingAddView: $isShowingAddView)
            }
        }.fullScreenCover(isPresented: $isShowingAddView) {
            NavigationView {
                AddView.init(isPresented: $isShowingAddView, date: viewModel.selectedDateStr)
            }.navigationViewStyle(.stack)
        }
        .onAppear {
            self.showingTabbar = true
        }
        .onChange(of: mainAddViewStatus) { newValue in
            viewModel.getCalendar()
            viewModel.getDayLines()
        }
        .onChange(of: isShowingAddView) { newValue in
            viewModel.getCalendar()
            viewModel.getDayLines()
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                viewModel.getCalendar()
            default:
                break
            }
        }

    }
}
//MARK: 총지출/총수입
struct TotalView: View {
    let scaler = Scaler.shared
    @ObservedObject var viewModel : CalendarViewModel
    @State var currency = CurrencyManager.shared.currentCurrency
    var body: some View {
        HStack(spacing: 0){
            HStack {
                VStack(alignment: .leading, spacing: scaler.scaleHeight(8)){
                    Text("총지출")
                        .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                        .foregroundColor(.white)
                    
                    Text("\(viewModel.totalOutcome.formattedString)\(currency)")
                        .foregroundColor(.white)
                        .font(viewModel.totalOutcome < 1000000000 ? Font.pretendardFont(.semiBold, size:scaler.scaleWidth(18)) : Font.pretendardFont(.semiBold, size:scaler.scaleWidth(15)))
                }
                Spacer()
            }
    
            .padding(.leading,scaler.scaleWidth(20))
            .padding(.vertical,scaler.scaleHeight(20))
       
            HStack {
                VStack(alignment: .leading, spacing: scaler.scaleHeight(8)){
                    Text("총수입")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                        .foregroundColor(.white)
                    Text("\(viewModel.totalIncome.formattedString)\(currency)")
                        .foregroundColor(.white)
                        .font(viewModel.totalIncome < 1000000000 ? Font.pretendardFont(.semiBold, size:scaler.scaleWidth(18)) : Font.pretendardFont(.semiBold, size:scaler.scaleWidth(15)))
                }
                Spacer()
            }
            .padding(.vertical,scaler.scaleHeight(20))
       
        }
        .frame(height: scaler.scaleHeight(80))
        .frame(width: scaler.scaleWidth(320))
        .background(Color.primary5)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        Spacer()
    }
    
}

//MARK: 캘린더 메인
struct CustomCalendarView: View {
    let scaler = Scaler.shared
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var isShowingMonthPicker : Bool
    @Binding var isShowingBottomSheet : Bool
    @Binding var isShowingAddView : Bool
  
    let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            // MARK: 날짜 헤더
            HStack {
                Image("icon_arrow_left")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: scaler.scaleWidth(24), height: scaler.scaleWidth(24))
       
                    .onTapGesture {
                        if viewModel.selectedView == 0 {
                            viewModel.moveOneMonthBackward()
                        } else if viewModel.selectedView == 1 {
                            viewModel.moveOneDayBackward()
                        }
                    }
                
                Button(action: {
                    withAnimation {
                        if viewModel.selectedView == 0 {
                            self.isShowingMonthPicker.toggle() // MARK: 연도, 월 변경 toggle
                        }
                    }
                }) {
                    Text(viewModel.selectedView == 0 ? "\(viewModel.selectedYearMonth)" : "\(viewModel.selectedMonth).\(viewModel.selectedDay)")
                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(20)))
                        .foregroundColor(.greyScale1)
                }.disabled(viewModel.selectedView == 1 ? true : false)
                
                Image("icon_arrow_right")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: scaler.scaleWidth(24), height: scaler.scaleWidth(24))
      
                    .onTapGesture {
                        if viewModel.selectedView == 0 {
                            viewModel.moveOneMonthForward()
                        } else if viewModel.selectedView == 1 {
                            viewModel.moveOneDayForward()
                        }
                    }
                Spacer()
                
                //MARK: 캘린더, 일별 toggle
                HStack(spacing: 0) {
                    ForEach(viewModel.options.indices, id:\.self) { index in
                        ZStack {
                            Rectangle()
                                .fill(Color.greyScale10)
                                .frame(width: scaler.scaleWidth(58))
                                .frame(height: scaler.scaleHeight(32))
                           
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(5)
                                .frame(width: scaler.scaleWidth(54))
                                .frame(height: scaler.scaleHeight(24))
                                .padding(.vertical, scaler.scaleHeight(4))
                                .padding(viewModel.selectedView == 0 ? .leading:.trailing , scaler.scaleWidth(4))
                                .opacity(viewModel.selectedView == index ? 1 : 0.01)
                                .onTapGesture {
                                    withAnimation(.interactiveSpring()) {
                                        viewModel.selectedView = index
                                    }
                                }
                                .overlay(
                                    Text(viewModel.options[index])
                                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(11)))
                                        .foregroundColor(viewModel.selectedView == index ? .greyScale2: .greyScale8)
                                        .padding(index == 0 ? .leading:.trailing , scaler.scaleWidth(4))
                                )
                            
                        }
                    }
                }
                .frame(width: scaler.scaleWidth(116))
                .frame(height: scaler.scaleHeight(32))
                .cornerRadius(8)
                 
            }
            .padding(.leading, scaler.scaleWidth(12))
            .padding(.trailing, scaler.scaleWidth(24))
            .padding(.bottom, scaler.scaleHeight(16))
            
            if viewModel.selectedView == 0 {
                ScrollView(showsIndicators: false) {
                    MonthCalendar(viewModel: viewModel, isShowingMonthPicker: $isShowingMonthPicker, isShowingBottomSheet: $isShowingBottomSheet)
                        .padding(.horizontal, scaler.scaleWidth(20))
                        .padding(.bottom, scaler.scaleHeight(70))
                }
            } else if viewModel.selectedView == 1 {
                DayLinesView(date: $viewModel.dayLinesDate, isShowingAddView: $isShowingAddView, viewModel: viewModel)
                    .padding(.horizontal, scaler.scaleWidth(20))
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
    let scaler = Scaler.shared
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var isShowingMonthPicker : Bool
    @Binding var isShowingBottomSheet : Bool
    
    let calendar = Calendar.current
    var body: some View {
            VStack(spacing: scaler.scaleHeight(16)) {
                // MARK: 날짜 가져오기
                let dates = viewModel.generateDates(for: viewModel.selectedDate)
                let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: viewModel.selectedDate))!
 
                let numberOfRows = dates.count / 7 + (dates.count % 7 == 0 ? 0 : 1)
                VStack(spacing: 0) {
                    //MARK: 요일
                    HStack(spacing: scaler.scaleWidth(27)) {
                        ForEach(viewModel.daysOfTheWeek, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                                .foregroundColor(.greyScale6)
                        }
                    }
                    .padding(.top,scaler.scaleHeight(18))
                    .padding(.bottom,scaler.scaleHeight(16))
                    .padding(.horizontal, scaler.scaleWidth(16))
                    
                    ForEach(0..<numberOfRows, id: \.self) { rowIndex in
                        HStack(spacing: scaler.scaleWidth(1)) {
                            ForEach(0..<7, id: \.self) { columnIndex in
                                if rowIndex * 7 + columnIndex < dates.count {
                                    let date = dates[rowIndex * 7 + columnIndex]
                                    let components = date.split(separator: "-")
                                    
                                    VStack {
                                        if let dayComponent = components.last {
                                            let day = String(dayComponent) // 01, 02, ..., 31
                                            if day == "0" {
                                                Text("")
                                                    .padding()
                                                    .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                                    .frame(maxWidth: .infinity)
                                                    .background(date == viewModel.totalToday ? Color.primary1 : Color.clear)
                                                    .foregroundColor(date == viewModel.totalToday ? .white : .greyScale2)
                                                    .clipShape(Circle())
                                            } else {
                                                Text("\(Int(day)!)")
                                                    .padding(.horizontal, scaler.scaleWidth(5))
                                                    .padding(.vertical, scaler.scaleHeight(6))
                                                    .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                                    .frame(maxWidth: .infinity)
                                                    .background(date == viewModel.totalToday ? Color.primary1 : Color.clear)
                                                    .foregroundColor(date == viewModel.totalToday ? .white : .greyScale2)
                                                    .clipShape(Circle())
                                                VStack {
                                                    ForEach(viewModel.expenses, id: \.self) { (expense: CalendarExpenses) in
                                                        if viewModel.extractYearMonth(from: viewModel.selectedDateStr) {
                                                            let extractedDay = viewModel.extractDay(from: expense.date)
                                                            let assetType = expense.categoryType
                                                            let money = expense.money
                                                            
                                                            if extractedDay == day && assetType == "OUTCOME" && money > 0 {
                                                                Text("-\(money.formattedString)")
                                                                    .lineLimit(1)
                                                            
                                                                    .font(money < 1000000 ? Font.pretendardFont(.medium, size:scaler.scaleWidth(9)) : Font.pretendardFont(.medium, size:scaler.scaleWidth(8)))
                                                                    .foregroundColor(.calendarRed)
                                                            }
                                                           
                                                            if extractedDay == day && assetType == "INCOME" && money > 0 {
                                                                Text("+\(money.formattedString)")
                                                                    .lineLimit(1)
                                                              
                                                                    .font(money < 1000000 ? Font.pretendardFont(.medium, size:scaler.scaleWidth(9)) : Font.pretendardFont(.medium, size:scaler.scaleWidth(8)))
                                                                    .foregroundColor(.blue1)
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    .frame(width: scaler.scaleWidth(44))
                                    .frame(height:scaler.scaleHeight(62))
                                    .background(Color.white)
                                    .onTapGesture { // 해당 날짜 터치할 경우
                                        if let dayComponent = components.last {
                                            let day = String(dayComponent)
                                            if day != "0" {
                                                viewModel.selectedDateStr = date // 0000-00-00
                                                viewModel.selectedDay = Int(dayComponent)!
                                                viewModel.selectedDate = Calendar.current.date(from: DateComponents(year: viewModel.selectedYear, month: viewModel.selectedMonth , day: Int(dayComponent)))!
                                                
                                                print("selected :\(viewModel.selectedDay)")
                                                isShowingBottomSheet.toggle()}
                                        }
                                    }
                                } else {
                                    Text("")
                                        .padding()
                                        .font(.pretendardFont(.regular, size: 12))
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .frame(height:scaler.scaleHeight(62))
                        .padding(.horizontal, scaler.scaleWidth(3))
                    }
                   // Spacer()
                }
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        //HomeView(showingTabbar: .constant(true))
        TotalView(viewModel: CalendarViewModel())
    }
}

