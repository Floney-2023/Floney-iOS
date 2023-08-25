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
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("수입")
                        .font(.pretendardFont(.medium, size: 12))
                        .foregroundColor(.greyScale12)
                    
                    Text("\(viewModel.dayLinesTotalIncome)원")
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
                    Text("\(viewModel.dayLinesTotalOutcome)원")
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
    }
}
struct DayLinesDetailView : View {
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var isShowingAddView : Bool
    var encryptionManager = CryptManager()
    @State var showingDetail = false
    @State private var selectedIndex = 0
    @State var selectedToggleTypeIndex = 0
    @State var selectedToggleType = ""
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
            VStack(spacing:38) {
                ScrollView(showsIndicators: false) {
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
                        Image("no_line")
                        Text("내역이 없습니다.")
                            .font(.pretendardFont(.medium, size: 12))
                            .foregroundColor(.greyScale6)
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
                                                let url = encryptionManager.decrypt(img, using: encryptionManager.key!)
                                                URLImage(url: URL(string: url!)!)
                                                    .aspectRatio(contentMode: .fill)
                                                    .clipShape(Circle())
                                                    .frame(width: 32, height: 32)
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
                                        
                                    }
                                }
                            }
                            .onTapGesture {
                                selectedIndex = index
                                showingDetail = true
                                if viewModel.dayLines[index]?.assetType == "OUTCOME" {
                                    selectedToggleTypeIndex = 0
                                    selectedToggleType = "지출"
                                } else if viewModel.dayLines[index]?.assetType == "INCOME" {
                                    selectedToggleTypeIndex = 1
                                    selectedToggleType = "수입"
                                } else if viewModel.dayLines[index]?.assetType == "BANK" {
                                    selectedToggleTypeIndex = 2
                                    selectedToggleType = "이체"
                                }
                                print("지출 수입 이체 인덱스 : \(selectedToggleTypeIndex)")
                                print("지출 수입 이체 : \(selectedToggleType)")
                                print("금액 : \(viewModel.dayLines[index]?.money)")
                                print("제외 여부 : \(viewModel.dayLines[index]?.exceptStatus)")
                                print("PK : \(viewModel.dayLines[index]?.id)")
                            }
                            .fullScreenCover(isPresented: $showingDetail) {
                                if let line = viewModel.dayLines[selectedIndex] {
                                    
                                    NavigationView {
                                        AddView(
                                            isPresented: $showingDetail,
                                            mode: "check",
                                            date: viewModel.selectedDateStr,
                                            money: String(line.money),
                                            assetType: line.category[0],
                                            category: line.category[1],
                                            content: line.content,
                                            toggleOnOff: line.exceptStatus,
                                            toggleType: selectedToggleType,
                                            selectedOptions: selectedToggleTypeIndex,
                                            lineId : line.id
                                        )
                                    }
                                }
                            }
                            
                        } //ForEach
                    } // else
                } //ScrollView
                .frame(maxHeight: .infinity)
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
