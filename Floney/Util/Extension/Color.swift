//
//  Color.swift
//  Floney
//
//  Created by 남경민 on 2023/03/03.
//

import SwiftUI
 
extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

extension Color {
    static let primary1 = Color(hex: "31C690")
    static let primary2 = Color(hex: "259D71")
    static let primary3 = Color(hex: "1A7454")
    static let primary4 = Color(hex: "135D42")
    static let primary5 = Color(hex: "56D1A5")
    static let primary6 = Color(hex: "7FDCBA")
    static let primary7 = Color(hex: "A7E7D0")
    static let primary8 = Color(hex: "CFF2E5")
    static let primary9 = Color(hex: "DFF6EE")
    static let primary10 = Color(hex: "F1F9F7")
    
    static let greyScale1 = Color(hex: "0D0D0D")
    static let greyScale2 = Color(hex: "262626")
    static let greyScale3 = Color(hex: "414141")
    static let greyScale4 = Color(hex: "595959")
    static let greyScale5 = Color(hex: "737373")
    static let greyScale6 = Color(hex: "8C8C8C")
    static let greyScale7 = Color(hex: "A6A6A6")
    static let greyScale8 = Color(hex: "BFBFBF")
    static let greyScale9 = Color(hex: "D9D9D9")
    static let greyScale10 = Color(hex: "F1F1F1")
    static let greyScale11 = Color(hex: "F4F4F4")
    static let greyScale12 = Color(hex: "FAFAFA")
    static let loadingGrey = Color(hex: "ADADAD")
    
    static let background1 = Color(hex: "F5F5F5")
    static let background2 = Color(hex: "F6F6F6")
    static let background3 = Color(hex: "FAFAFA")

    static let calendarRed = Color(hex: "F14F4F")
    static let red1 = Color(hex: "AD1F25")
    static let red2 = Color(hex: "E56E73")
    static let red3 = Color(hex: "EFA9AB")
    
    static let yellow1 = Color(hex: "DDBB09")
    static let yellow2 = Color(hex: "F8DC4A")
    static let yellow3 = Color(hex: "FAE784")
    
    static let blue1 = Color(hex: "114EEE")
    static let blue2 = Color(hex: "4373F1")
    static let blue3 = Color(hex: "A0B8F8")
    static let blue4 = Color(hex: "99C4FF")
    static let blue5 = Color(hex: "CCE1FF")
    
    static let orange1 = Color(hex: "CE4A00")
    static let orange2 = Color(hex: "FF5C00")
    static let orange3 = Color(hex: "FF965B")
    static let orange4 = Color(hex: "FFBE99")
    static let orange5 = Color(hex: "FFDECC")
    
    static let indigo1 = Color(hex: "35347F")
    static let indigo2 = Color(hex: "4A48B0")
    static let indigo3 = Color(hex: "706EC4")
    
    static let purple1 = Color(hex: "654CFF")
    static let purple2 = Color(hex: "9B8BFF")
    static let purple3 = Color(hex: "D3CCFF")

    static let alertGrey1 = Color(hex: "F2F2F2")
    static let alertGrey2 = Color(hex: "3C3C43")
    static let alertBlue = Color(hex: "007AFF")
    static let alertRed = Color(hex: "FF3B30")
    
    static let linear = Color(hex:"98E7CA")

}
