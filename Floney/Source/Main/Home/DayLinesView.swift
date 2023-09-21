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
        }//.padding(20)
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
    @ObservedObject var viewModel : CalendarViewModel
    @State var totalIncome = 0
    @State var totalOutcome = 0
    @State var currency = CurrencyManager.shared.currentCurrency
    
    var body: some View {
        HStack() {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("수입")
                        .font(.pretendardFont(.medium, size: 12))
                        .foregroundColor(.greyScale12)
                    
                    Text("\(viewModel.dayLinesTotalIncome)\(currency)")
                        .font(.pretendardFont(.semiBold, size: 18))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(20)
            HStack{
                VStack(alignment: .leading, spacing: 8) {
                    Text("지출")
                        .font(.pretendardFont(.medium, size: 12))
                        .foregroundColor(.greyScale12)
                    Text("\(viewModel.dayLinesTotalOutcome)\(currency)")
                        .font(.pretendardFont(.semiBold, size: 18))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.primary5)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
struct DayLinesDetailView : View {
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var isShowingAddView : Bool
    //var encryptionManager = CryptManager()
    @State var showingDetail = false
    @State private var selectedIndex = 0
    @State var selectedToggleTypeIndex = 0
    @State var selectedToggleType = ""
    var lineModel = LineModel()
    var body: some View {
        VStack(spacing:34) {
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
            ScrollView(showsIndicators: false) {
                VStack(spacing:28) {
                if Calendar.current.component(.day, from: viewModel.selectedDate) == 1 {
                    
                    if viewModel.dayLineCarryOver.carryOverStatus {
                        HStack {
                            if viewModel.seeProfileImg {
                                Image("book_profile_32")
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                            }
                            VStack(alignment: .leading, spacing: 3){
                                Text("이월")
                                    .font(.pretendardFont(.semiBold, size: 14))
                                    .foregroundColor(.greyScale2)
                                Text("-")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            Text("\(Int(viewModel.dayLineCarryOver.carryOverMoney))")
                                .font(.pretendardFont(.semiBold, size: 16))
                                .foregroundColor(.greyScale2)
                        }
                        
                    }
                }
                if viewModel.dayLines.count == 0 {
                    // 1일이고, 이월금액이 존재한다면
                    if Calendar.current.component(.day, from: viewModel.selectedDate) == 1 && viewModel.dayLineCarryOver.carryOverStatus {
                    } else {
                        Spacer()
                        VStack(spacing:5) {
                            Image("no_line")
                            Text("내역이 없습니다.")
                                .font(.pretendardFont(.medium, size: 12))
                                .foregroundColor(.greyScale6)
                        }
                        Spacer()
                    }
                } else {
                    
                        ForEach(viewModel.dayLines.indices, id: \.self) { index in
                            HStack {
                                if viewModel.seeProfileImg {
                                    if let userImg = viewModel.userImages {
                                        if let img = userImg[index] {
                                            if img == "user_default" {
                                                Image("user_profile_32")
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                                
                                            } else if img.hasPrefix("random"){
                                                let components = img.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                                let random = components.first!  // "random"
                                                let number = components.last!   // "5"
                                                Image("img_user_random_profile_0\(number)_32")
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
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
                                                    .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                                    .frame(width: 32, height: 32) //resize
                                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                                
                                            }
                                        } else { //null
                                            Image("book_profile_32")
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        }
                                    } else {
                                        Image("user_profile_32")
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        
                                    }
                                }
                                if let line = viewModel.dayLines[index] {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("\(line.content)")
                                            .font(.pretendardFont(.semiBold, size: 14))
                                            .foregroundColor(.greyScale2)
                                        HStack {
                                            ForEach(line.category, id: \.self) { category in
                                                Text("\(category)‧")
                                                    .font(.pretendardFont(.medium, size: 12))
                                                    .foregroundColor(.greyScale6)
                                            }
                                            
                                        }
                                    }
                                    
                                    Spacer()
                                    if line.assetType == "INCOME" {
                                        Text("+\(line.money)")
                                            .font(.pretendardFont(.semiBold, size: 16))
                                            .foregroundColor(.greyScale2)
                                    } else if line.assetType == "OUTCOME" {
                                        Text("-\(line.money)")
                                            .font(.pretendardFont(.semiBold, size: 16))
                                            .foregroundColor(.greyScale2)
                                        
                                    } else if line.assetType == "BANK" {
                                        Text("-\(line.money)")
                                            .font(.pretendardFont(.semiBold, size: 16))
                                            .foregroundColor(.greyScale2)
                                        
                                    }
                                }
                            }
                            .onTapGesture {
                                
                                self.selectedIndex = index
                                
                                if let line = viewModel.dayLines[selectedIndex] {
                                    if viewModel.dayLines[index]?.assetType == "OUTCOME" {
                                        lineModel.selectedOptions = 0
                                        lineModel.toggleType = "지출"
                                    } else if viewModel.dayLines[index]?.assetType == "INCOME" {
                                        lineModel.selectedOptions = 1
                                        lineModel.toggleType = "수입"
                                    } else if viewModel.dayLines[index]?.assetType == "BANK" {
                                        lineModel.selectedOptions = 2
                                        lineModel.toggleType = "이체"
                                    }
                                    lineModel.mode = "check"
                                    lineModel.lineId = line.id
                                    print("지출 수입 이체 인덱스 : \(self.selectedToggleTypeIndex)")
                                    print("지출 수입 이체 : \(self.selectedToggleType)")
                                    print("금액 : \(self.viewModel.dayLines[index]?.money)")
                                    print("제외 여부 : \(self.viewModel.dayLines[index]?.exceptStatus)")
                                    print("PK : \(self.viewModel.dayLines[index]?.id)")
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.showingDetail = true
                                }
                                
                            }
                            .fullScreenCover(isPresented: $showingDetail) {
                                if let line = viewModel.dayLines[selectedIndex] {
                                    
                                    NavigationView {
                                        AddView(
                                            isPresented: $showingDetail,
                                            lineModel : lineModel,
                                            date : viewModel.selectedDateStr,
                                            money: String(line.money),
                                            assetType : line.category[0],
                                            category: line.category[1],
                                            content : line.content,
                                            toggleOnOff: line.exceptStatus,
                                            writer: line.userNickName
                                        )
                                        .transition(.moveAndFade)
                                    }
                                }
                            }
                            
                        } //ForEach
                    } // else
                } //ScrollView
            }.frame(maxHeight: .infinity)
        }
        .frame(height: 366)
        .padding(20)
        .background(Color.white)
        .cornerRadius(12)
        
    }
}

struct DateCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        //DayLinesView(date : .constant("2023-06-20"), isShowingAddView: .constant(false), viewModel: CalendarViewModel())
        DayTotalView(viewModel: CalendarViewModel())
    }
}
