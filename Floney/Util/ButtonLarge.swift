//
//  ButtonLarge.swift
//  Floney
//
//  Created by 남경민 on 2023/04/13.
//


import SwiftUI

struct ButtonLarge: View {
    let scaler = Scaler.shared
    var label: String
    var background: Color = .white
    var isAbleCopied = false
    var textColor: Color
    var strokeColor : Color
    var fontWeight : Font.PretendardFont = .regular
    @State var showAlert = false
    var action: (() -> ())
    
    let cornorRadius: CGFloat = 12
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                ZStack {
                Text(label)
                    .frame(maxWidth: .infinity)
                    .padding(scaler.scaleHeight(16))
                    .foregroundColor(textColor)
                    .font(.pretendardFont(fontWeight, size: scaler.scaleWidth(14)))
                    .lineLimit(1)
                if isAbleCopied {
                        HStack {
                            Spacer()
                            Image("icon_copy")
                                .onTapGesture {
                                    // 클립보드에 값 복사하기
                                    UIPasteboard.general.string = label
                                    showAlert = true
                                }
                                .alert(isPresented: $showAlert) {
                                    Alert(title: Text("초대 코드 복사"), message: Text("초대 코드가 복사되었습니다."), dismissButton: .default(Text("OK")))
                                }
                                .padding(.trailing, scaler.scaleWidth(16))
                        }
                    }
                        
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: cornorRadius)
                    .stroke(strokeColor, lineWidth: 1)
            )
        }
        .background(background)
        .cornerRadius(cornorRadius)
    }
}

