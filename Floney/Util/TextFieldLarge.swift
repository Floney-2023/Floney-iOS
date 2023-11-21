//
//  TextFieldLarge.swift
//  Floney
//
//  Created by 남경민 on 2023/05/31.
//

import SwiftUI
import Combine

struct TextFieldLarge: View {
    @Binding var label : String
    @Binding var content : String

    var body: some View {
        
        CustomTextField(text: $content, placeholder: label, keyboardType: .decimalPad, alignment: .center, placeholderColor: .greyScale6)
            .onReceive(Just(content)) { newValue in
                content = formatBudget(content, hasDecimal: CurrencyManager.shared.hasDecimalPoint)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
    
    
    private func formatBudget(_ budget: String, hasDecimal: Bool) -> String {
        if hasDecimal {
            return formatDecimal(budget, maxDigits: 9, maxDecimalPlaces: 2)
        } else {
            return formatInteger(budget, maxDigits: 11)
        }
    }
    
    private func formatDecimal(_ budget: String, maxDigits: Int, maxDecimalPlaces: Int) -> String {
        let numberComponents = budget.components(separatedBy: ".")
        let decimalPart = numberComponents.count > 1 ? String(numberComponents[1].prefix(maxDecimalPlaces)) : ""
        let integerPart = String(numberComponents[0].prefix(maxDigits))
        
        return numberComponents.count > 1 ? "\(integerPart).\(decimalPart)" : integerPart
    }
    
    private func formatInteger(_ budget: String, maxDigits: Int) -> String {
        // 숫자만 추출
        let numbersOnly = budget.filter { $0.isNumber }
        // 최대 길이까지 잘라내기
        return String(numbersOnly.prefix(maxDigits))
    }
}

