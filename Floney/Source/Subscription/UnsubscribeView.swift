//
//   UnsubscribeView.swift
//  Floney
//
//  Created by 남경민 on 2023/09/14.
//

import SwiftUI

struct UnsubscribeView: View {
    @Binding var showingTabbar : Bool
    @Binding var isShowing : Bool
    
    let columns: [GridItem] = [
        .init(.fixed(UIScreen.main.bounds.width * 0.43), spacing: 0),
        .init(.flexible(), spacing: 0),
        .init(.flexible(), spacing: 0)
    ]
    let sampleData = [
        ["기능", "Basic", "Plus+"],
        ["모든 가계부 기능", "icon_check_circle_disabled", "icon_check_circle_activated"],
        ["광고 제거", "icon_cancel_circle_disabled", "icon_check_circle_activated"],
        ["사용 가능 인원", "2명", "4명"],
        ["가계부 수", "1개", "2개"],
        ["엑셀 내보내기", "icon_check_circle_disabled", "icon_check_circle_activated"]
    ]
    let imageNames = ["icon_cancel_circle_disabled", "icon_check_circle_disabled", "icon_check_circle_activated"]
    
    var body: some View {
        HStack {
            Spacer()
            Image("icon_close")
                .padding(.trailing, 20)
                .onTapGesture {
                    showingTabbar = true
                    isShowing = false
                }
            
        }
        .padding(.top, 18)
        .padding(.bottom,38)
        VStack {
            HStack {
                Text("구독을\n해지하시겠어요?")
                    .font(.pretendardFont(.bold, size: 24))
                    .foregroundColor(.greyScale1)
                Spacer()
                Image("illust_unscribe")
            }
            HStack {
                Text("다음 달 결제일부터 자동결제가 취소되며\n이후 모든 Plus 혜택을 이용하실 수 없습니다.")
                    .font(.pretendardFont(.medium, size: 13))
                    .foregroundColor(.greyScale7)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.bottom, 40)
            LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
                ForEach(0..<6, id: \.self) { row in
                    ForEach(0..<3, id: \.self) { column in
                        let cellData = sampleData[row][column]
                        if imageNames.contains(cellData) {
                            Image(cellData)  // Use the image name directly from the data
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                .background(cellBackgroundColor(column: column))
                                .border(Color.tableGrey, width: 0.5)
                        } else {
                            if column == 0 {
                                Text(cellData)
                                    .font(fontFor(row: row, column: column))
                                    .foregroundColor(colorFor(row: row, column: column))
                                    .frame(alignment: .leading)
                                    .frame(minWidth: 0, maxWidth: .infinity,minHeight: 50, maxHeight: 50)
                                    .background(cellBackgroundColor(column: column))
                                    .border(Color.tableGrey, width: 0.5)
                            } else {
                                Text(cellData)
                                    .font(fontFor(row: row, column: column))
                                    .foregroundColor(colorFor(row: row, column: column))
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                    .background(cellBackgroundColor(column: column))
                                    .border(Color.tableGrey, width: 0.5)
                            }
                        }
                    }
                }
            }
            .background(Color.white) // 배경색 지정
            .cornerRadius(12)       // 원하는 cornerradius 값
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.tableGrey, lineWidth: 1)
            )
            .padding(5)              // 적당한 padding을 추가해서 더 좋은 모양을 만듭니다.
            
            Spacer()
            VStack(spacing:10) {
                Button {
                    //self.isNextToMySubscription = true
                    isShowing = false
                } label: {
                    Text("구독 유지하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.greyScale2)
                .cornerRadius(12)
                Button {
                    //self.isNextToMySubscription = true
                    if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } label: {
                    Text("해지하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .font(.pretendardFont(.medium, size: 14))
                        .foregroundColor(.greyScale7)
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.greyScale10)
                .cornerRadius(12)

            }
        }.padding(.horizontal, 24)
    }
    
    func cellBackgroundColor(column: Int) -> Color {
        switch column {
        case 0:
            return Color.clear
        case 1:
            return Color.clear
        case 2:
            return Color.primary10
        default:
            return Color.clear
        }
    }
    func fontFor(row: Int, column: Int) -> Font {
        if row == 0 {
            return .pretendardFont(.bold, size: 12)
            
        } else if column == 0 {
            return .pretendardFont(.semiBold, size: 12)
            
        } else if (row == 3 || row == 4) && (column == 1 || column == 2) {
            return .pretendardFont(.semiBold, size: 14)
        } else {
            return .pretendardFont(.bold, size: 12)
        }
    }
    
    func colorFor(row: Int, column: Int) -> Color {
        if row == 0 || column == 0 {
            return Color.greyScale3 // Assuming greyscale3
        } else if (row == 3 || row == 4) && column == 1 {
            return Color.greyScale7 // Assuming greyscale7
        } else if (row == 3 || row == 4) && column == 2 {
            return Color.primary1 // Assuming primary1
        } else {
            return Color.greyScale1
        }
    }
    
}

struct UnsubscribeView_Previews: PreviewProvider {
    static var previews: some View {
        UnsubscribeView(showingTabbar: .constant(false), isShowing: .constant(true))
    }
}
