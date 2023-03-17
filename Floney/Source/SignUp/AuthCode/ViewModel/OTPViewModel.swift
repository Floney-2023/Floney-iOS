//
//  OTPViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/03/17.
//

import SwiftUI

class OTPViewModel: ObservableObject {
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
}
