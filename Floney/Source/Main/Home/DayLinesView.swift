//
//  CalendarView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/13.
//

import SwiftUI
import Kingfisher

struct DayLinesView: View {
    @Binding var date: String
    @Binding var isShowingAddView : Bool
    @ObservedObject var viewModel : CalendarViewModel
    var body: some View {
        VStack {
            DayTotalView(viewModel: viewModel)
            DayLinesDetailView(viewModel: viewModel, isShowingAddView: $isShowingAddView)
            Spacer()
        }
        .background(Color.clear)
        .onAppear{
            print("date : \(date)")
            viewModel.dayLinesDate = viewModel.selectedDateStr
            viewModel.getDayLines()
        }
        .onChange(of: isShowingAddView) { newValue in
            viewModel.getDayLines()
        }
    }
}

struct DayTotalView : View {
    let scaler = Scaler.shared
    @ObservedObject var viewModel : CalendarViewModel
    @State var totalIncome = 0
    @State var totalOutcome = 0
    @State var currency = CurrencyManager.shared.currentCurrency
    
    var body: some View {
        
        HStack(spacing: 0){
            HStack {
                VStack(alignment: .leading, spacing: scaler.scaleHeight(8)){
                    Text("수입")
                        .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                        .foregroundColor(.white)
                    
                    Text("\(viewModel.dayLinesTotalIncome.formattedString)\(currency)")
                        .foregroundColor(.white)
                        .font(viewModel.dayLinesTotalIncome < 1000000000 ? Font.pretendardFont(.semiBold, size:scaler.scaleWidth(18)) : Font.pretendardFont(.semiBold, size:scaler.scaleWidth(15)))
                }
                Spacer()
            }
            
            .padding(.leading,scaler.scaleWidth(20))
            .padding(.vertical,scaler.scaleHeight(20))
            
            HStack {
                VStack(alignment: .leading, spacing: scaler.scaleHeight(8)){
                    Text("지출")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                        .foregroundColor(.white)
                    Text("\(viewModel.dayLinesTotalOutcome.formattedString)\(currency)")
                        .foregroundColor(.white)
                        .font(viewModel.dayLinesTotalOutcome < 1000000000 ? Font.pretendardFont(.semiBold, size:scaler.scaleWidth(18)) : Font.pretendardFont(.semiBold, size:scaler.scaleWidth(15)))
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
        
    }
}
struct DayLinesDetailView : View {
    let scaler = Scaler.shared
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var isShowingAddView : Bool
    @State var showingDetail = false
    @State private var selectedIndex = 0
    @State var selectedToggleTypeIndex = 0
    @State var selectedToggleType = ""
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Text("내역")
                    .font(.pretendardFont(.bold, size:scaler.scaleWidth(16)))
                    .foregroundColor(.greyScale1)
                    .padding(.top, scaler.scaleHeight(20))
                    .padding(.bottom, scaler.scaleHeight(16))
                Spacer()
                Text("내역 추가")
                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(12)))
                    .foregroundColor(.primary2)
                    .padding(.top, scaler.scaleHeight(21))
                    .padding(.bottom, scaler.scaleHeight(19))
                    .onTapGesture {
                        isShowingAddView = true
                    }
            }
            VStack(spacing:0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing:scaler.scaleHeight(38)) {
                        if Calendar.current.component(.day, from: viewModel.selectedDate) == 1 {
                            if viewModel.dayLineCarryOver.carryOverStatus {
                                HStack(spacing:scaler.scaleWidth(16)) {
                                    if viewModel.seeProfileImg {
                                        Image("book_profile_32")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                        
                                    }
                                    VStack(alignment: .leading, spacing: scaler.scaleHeight(8)){
                                        Text("이월")
                                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale2)
                                        Text("-")
                                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                            .foregroundColor(.greyScale6)
                                    }
                                    Spacer()
                                    Text("\(viewModel.dayLineCarryOver.carryOverMoney.formattedString)")
                                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                                        .foregroundColor(.greyScale2)
                                }
                                .frame(height: scaler.scaleHeight(34))
                                
                            }
                        }
                        if viewModel.dayLines.count == 0 {
                            // 1일이고, 이월금액이 존재한다면
                            if Calendar.current.component(.day, from: viewModel.selectedDate) == 1 && viewModel.dayLineCarryOver.carryOverStatus {
                                
                            } else {
                                Spacer()
                                VStack(spacing:scaler.scaleHeight(10)) {
                                    Image("no_line")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: scaler.scaleWidth(38), height: scaler.scaleWidth(64))
                                    
                                    Text("내역이 없습니다.")
                                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                        .foregroundColor(.greyScale6)
                                    
                                }
                                .frame(maxHeight: .infinity)
                                Spacer()
                                
                            }
                        } else {
                            ForEach(viewModel.dayLines.indices, id: \.self) { index in
                                HStack(spacing:scaler.scaleWidth(16)) {
                                    if viewModel.seeProfileImg {
                                        if let userImg = viewModel.userImages {
                                            if let img = userImg[index] {
                                                if img == "user_default" {
                                                    Image("user_profile_32")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                        .clipShape(Circle())
                                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                                    
                                                } else if img.hasPrefix("random"){
                                                    let components = img.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                                    let random = components.first!  // "random"
                                                    let number = components.last!   // "5"
                                                    Image("img_user_random_profile_0\(number)_32")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                        .clipShape(Circle())
                                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                                }
                                                else  {
                                                    
                                                    let url = URL(string : img)
                                                    KFImage(url)
                                                        .placeholder { //플레이스 홀더 설정
                                                            Image("user_profile_32")
                                                        }.retry(maxCount: 3, interval: .seconds(5)) //재시도
                                                        .onSuccess { success in //성공
                                                            print("succes: \(success)")
                                                        }
                                                        .onFailure { error in //실패
                                                            print("failure: \(error)")
                                                        }
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                        .clipShape(Circle())
                                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                                    
                                                }
                                            } else { //null
                                                Image("user_profile_32")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                            }
                                        } else {
                                            Image("user_profile_32")
                                                .resizable()
                                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                            
                                        }
                                    }
                                    if let line = viewModel.dayLines[index] {
                                        VStack(alignment: .leading, spacing:scaler.scaleHeight(8)) {
                                            Text("\(line.description)")
                                                .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                                .foregroundColor(.greyScale2)
                                            HStack(spacing:0) {
                                                Text("\(line.assetSubCategory)")
                                                Text(" ‧ ")
                                                Text("\(line.lineSubCategory)")
                                            }
                                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                            .foregroundColor(.greyScale6)
                                        }
                                        
                                        Spacer()
                                        
                                        if line.lineCategory == "INCOME" {
                                            Text("+\(line.money.formattedString)")
                                                .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(16)))
                                                .foregroundColor(.greyScale2)
                                        } else if line.lineCategory == "OUTCOME" {
                                            Text("-\(line.money.formattedString)")
                                                .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                                                .foregroundColor(.greyScale2)
                                            
                                        } else if line.lineCategory == "BANK" {
                                            Text("-\(line.money.formattedString)")
                                                .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                                                .foregroundColor(.greyScale2)
                                            
                                        }
                                    }
                                }
                                .background(Color.white)
                                .onTapGesture {
                                    LoadingManager.shared.update(showLoading: true, loadingType: .progressLoading)
                                    self.selectedIndex = index
                                    
                                    if let line = viewModel.dayLines[selectedIndex] {
                                        if viewModel.dayLines[index]?.lineCategory == "OUTCOME" {
                                            selectedToggleTypeIndex = 0
                                            selectedToggleType = "지출"
                                        } else if viewModel.dayLines[index]?.lineCategory == "INCOME" {
                                            selectedToggleTypeIndex = 1
                                            selectedToggleType = "수입"
                                        } else if viewModel.dayLines[index]?.lineCategory == "BANK" {
                                            selectedToggleTypeIndex = 2
                                            selectedToggleType = "이체"
                                        }
                                        
                                    }
                                    LoadingManager.shared.update(showLoading: false, loadingType: .progressLoading)
                                    self.showingDetail = true
                                }
                                .frame(height: scaler.scaleHeight(34))
                                .fullScreenCover(isPresented: $showingDetail) {
                                    if let line = viewModel.dayLines[selectedIndex] {
                                        NavigationView {
                                            AddView(
                                                isPresented: $showingDetail,
                                                mode : "check",
                                                lineId : line.id,
                                                toggleType : selectedToggleType, // 지출, 수입, 이체
                                                selectedOptions : selectedToggleTypeIndex,
                                                date : viewModel.selectedDateStr,
                                                money: String(line.money.formattedString),
                                                assetType : line.assetSubCategory,
                                                category: line.lineSubCategory,
                                                content : line.description,
                                                toggleOnOff: line.exceptStatus,
                                                writer: line.writerNickname,
                                                repeatDuration: line.repeatDuration
                                            )
                                        }
                                        .transition(.moveAndFade)
                                        .navigationViewStyle(.stack)
                                    }
                                }
                            } //ForEach
                            
                        } // else
                    }.padding(.top, scaler.scaleHeight(18))
                        .padding(.bottom, scaler.scaleHeight(18))
                } //ScrollView
                
            }
        }
        .padding(.horizontal, scaler.scaleWidth(20))
        .frame(height: scaler.scaleHeight(366))
        .background(Color.white)
        .cornerRadius(12)
        .onChange(of : isShowingAddView) { newValue in
            viewModel.getDayLines()
            viewModel.getCalendar()
        }
        .onChange(of : showingDetail) { newValue in
            viewModel.getDayLines()
            viewModel.getCalendar()
        }
        
    }
}

struct DateCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DayTotalView(viewModel: CalendarViewModel())
    }
}
