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
            VStack(alignment: .leading, spacing: 8) {
                Text("수입")
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(.greyScale12)
                
                Text("\(viewModel.dayLinesTotalIncome)")
                    .font(.pretendardFont(.semiBold, size: 18))
                    .foregroundColor(.white)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 8) {
                Text("지출")
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(.greyScale12)
                Text("\(viewModel.dayLinesTotalOutcome)")
                    .font(.pretendardFont(.semiBold, size: 18))
                    .foregroundColor(.white)
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(Color.primary5)
        .cornerRadius(12)
    }
}
struct DayLinesDetailView : View {
    @ObservedObject var viewModel : CalendarViewModel
    @Binding var isShowingAddView : Bool
    var encryptionManager = CryptManager()
    var body: some View {
        VStack(spacing:88) {
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
            VStack {
                ScrollView {
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
                                                    .frame(width: 34, height: 34)
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
                        } //ForEach
                    } // else
                } //ScrollView
            }
            Spacer()
        }
        .frame(height: 366)
        .padding(20)
        .background(Color.white)
        .cornerRadius(12)
        
    }
}

struct DateCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DayLinesView(date : .constant("2023-06-20"), isShowingAddView: .constant(false), viewModel: CalendarViewModel())
    }
}
