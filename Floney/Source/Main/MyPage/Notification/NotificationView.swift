//
//  NotificationView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/23.
//

import SwiftUI

struct NotificationView: View {
    let scaler = Scaler.shared
    @StateObject var viewModel = NotiViewModel()
    @Binding var showingTabbar : Bool
    @State private var selectedTab : Int = 0
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        
        VStack {
            HStack(spacing:0) {
               // if !viewModel.bookNotiList.isEmpty {
                
                ForEach(Array(viewModel.bookNotiList.enumerated()), id: \.element) { index, book in
                        Button(action: {
                            withAnimation {
                                selectedTab = index
                            }
                        }) {
                            VStack {
                                Text(viewModel.bookNotiList.isEmpty ? "가계부" : "\(book.bookName)")
                                Rectangle()
                                    .fill(selectedTab == index ? Color.primary1 : Color.background2)
                                    .frame(height:scaler.scaleHeight(4))
                                    .cornerRadius(20)
                            }
                        }
                        .font(.pretendardFont(.medium,size:scaler.scaleWidth(14)))
                        .foregroundColor(selectedTab == index ? .greyScale2 : .greyScale8)
                    }
                //}
            }
            .padding(.top,scaler.scaleHeight(12))
            .padding(.horizontal,scaler.scaleWidth(20))
            .padding(.bottom,scaler.scaleHeight(14))
            
            // 스와이프 가능한 알림 목록
            //GeometryReader { geometry in
              //  HStack(spacing: 0) {
                  //  ForEach(viewModel.bookNotiList, id:\.self) { book in
                            //  if !viewModel.bookNotiList.isEmpty {
            if viewModel.bookNotiList.count == viewModel.myBooks.count {
                VStack {
                    if let bookNoti = viewModel.bookNotiList[selectedTab].notiList {
                        if bookNoti.isEmpty {
                            
                            VStack(spacing:scaler.scaleHeight(12)) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width:scaler.scaleWidth(50), height:scaler.scaleHeight(84))
                                    .background(
                                        Image("no_line_2")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width:scaler.scaleWidth(50), height:scaler.scaleHeight(84))
                                    )
                                Text("알림 내역이 없습니다.")
                                    .font(.pretendardFont(.medium,size: scaler.scaleWidth(12)))
                                    .foregroundColor(.greyScale6)
                            }
                            .padding(.bottom,scaler.scaleHeight(100))
                            //.frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                            
                        } else {
                            ScrollView {
                                ForEach(bookNoti, id:\.self) { noti in
                                    HStack {
                                        Image(noti.imgUrl)
                                            .padding(.leading, scaler.scaleWidth(20))
                                            .padding(.vertical, scaler.scaleHeight(20))
                                        VStack(alignment: .leading, spacing: scaler.scaleHeight(10)) {
                                            Text(noti.body)
                                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                                                .foregroundColor(.greyScale2)
                                            Text(timeAgoSinceDate(dateString: noti.date, numericDates: true))
                                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                                .foregroundColor(.greyScale8)
                                        }
                                        Spacer()
                                    }
                                    .background(Color.primary10)
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal,scaler.scaleWidth(20))
                            //.frame(width: geometry.size.width)
                        }
                    }
                }
                // }
                //.frame(maxWidth:.infinity, maxHeight:.infinity)
                // .offset(x: -CGFloat(self.selectedTab) * geometry.size.width)
                // .offset(x: self.translation)
                // .animation(.spring())
                /*
                 .gesture(
                 DragGesture()
                 .updating($translation) { value, state, _ in
                 state = value.translation.width
                 }
                 .onEnded { value in
                 let offset = value.translation.width / geometry.size.width
                 let newIndex = (CGFloat(self.selectedTab) - offset).rounded()
                 self.selectedTab = min(max(Int(newIndex), 0), viewModel.bookNotiList.count - 1)
                 }
                 
                 )*/
                //}
            }
        }
        .customNavigationBar(
            leftView: { BackButtonBlack() },
            centerView: {
                Text("가계부 알림")
                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                .foregroundColor(.greyScale1) }
        )
        .onAppear{
            showingTabbar = false
            viewModel.getMyPage()
        }
    }
    
    func timeAgoSinceDate(dateString: String, numericDates:Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            return "Invalid date format"
        }
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let unitFlags : NSCalendar.Unit = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now as Date) ? date : now as Date
        let components = calendar.components(unitFlags, from: earliest as Date, to: latest as Date)
        if let year = components.year, let month = components.month, let weekOfYear = components.weekOfYear, let day = components.day, let hour = components.hour, let minute = components.minute {
            if (year >= 2) {
                return "\(year)년 전"
            } else if (year >= 1){
                if (numericDates){
                    return "1년 전"
                } else {
                    return "작년"
                }
            } else if (month >= 2) {
                return "\(month)달 전"
            } else if (month >= 1){
                if (numericDates){
                    return "1달 전"
                } else {
                    return "저번 달"
                }
            } else if (weekOfYear >= 2) {
                return "\(weekOfYear)주 전"
            } else if (weekOfYear >= 1){
                if (numericDates){
                    return "1주 전"
                } else {
                    return "저번 주"
                }
            } else if (day >= 2) {
                return "\(day)일 전"
            } else if (day >= 1){
                if (numericDates){
                    return "1일 전"
                } else {
                    return "어제"
                }
            } else if (hour >= 2) {
                return "\(hour)시간 전"
            } else if (hour >= 1){
                if (numericDates){
                    return "1시간 전"
                } else {
                    return "1시간 전"
                }
            } else if (minute >= 2) {
                return "\(minute)분 전"
            } else if (minute >= 1){
                if (numericDates){
                    return "1분 전"
                } else {
                    return "1분 전"
                }
            } else {
                return "방금"
            }
        }
        return "방금"
    }

    
}


struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(viewModel: NotiViewModel(), showingTabbar: .constant(false))
    }
}
