//
//  CalendarView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/13.
//

import SwiftUI

struct DayLinesView: View {
    @Binding var date: Date
    var body: some View {
        ScrollView {
            VStack {
                DayTotalView()
                DayLinesDetailView()
            }//.padding(20)
        }.background(Color.clear)
    }
}

struct DayTotalView : View {
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 8) {
                Text("수입")
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(.greyScale12)
                Text("99999999원")
                    .font(.pretendardFont(.semiBold, size: 18))
                    .foregroundColor(.white)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 8) {
                Text("지출")
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(.greyScale12)
                Text("99999999원")
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
    var dayLine = DayLinesViewModel()
    let dayLinesResponse =
    [
        DayLinesResults(money: 10000, img: "", category: ["식비"], assetType: "OUTCOME", content: "점심"),
        DayLinesResults(money: 10000, img: "", category: ["식비"], assetType: "OUTCOME", content: "저녁"),
        DayLinesResults(money: 10000, img: "", category: ["급여"], assetType: "INCOME", content: "급여"),
        DayLinesResults(money: 10000, img: "", category: ["급여"], assetType: "INCOME", content: "알바")
    ]
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
            }
            /*
            List {
                ForEach(dayLinesResponse, id: \.self) { day in
                    HStack {
                        Image("icon_profile")
                        VStack {
                            Text("\(day.content)")

                        }
                    }
                }
            }
             */
            VStack {
                Image("no_line")
                Text("내역이 없습니다.")
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(.greyScale6)
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
        DayLinesView(date : .constant(Date()))
    }
}
