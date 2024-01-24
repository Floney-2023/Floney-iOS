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
                //content = formatBudget(content, hasDecimal: CurrencyManager.shared.hasDecimalPoint)
                content = validateAndFormatAmount(budget: content)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
    /*
    func validateAndFormatAmount(budget: String) -> String {
        // 숫자와 소수점만 허용
        let filteredAmount = budget.filter { "0123456789.".contains($0) }
        if (filteredAmount.first == "0" && filteredAmount.count > 1) {
            return ""
        }

        // 최대 금액 검증
        if CurrencyManager.shared.hasDecimalPoint {
            guard let value = Double(filteredAmount), filteredAmount.count > 11 else {
                return ""
            }
            return formatAmount(value)
        
        } else {
            guard let value = Int(filteredAmount), filteredAmount.count > 11 else {
                return ""
            }
            return formatAmount(value)
        }
    }

    func formatAmount(_ value: Any) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = CurrencyManager.shared.hasDecimalPoint ? 0 : 2

        if let doubleValue = value as? Double {
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? ""
        } else if let intValue = value as? Int {
            return numberFormatter.string(from: NSNumber(value: intValue)) ?? ""
        } else {
            // 적절한 숫자 타입이 아닌 경우
            return ""
        }
    }*/
    
    func validateAndFormatAmount(budget: String) -> String {
        // 숫자와 소수점만 허용
        let filteredAmount = budget.filter { "0123456789.".contains($0) }
        
        if (filteredAmount.first == "0" && filteredAmount.count > 1) {
            return ""
        }
        // 11자리를 초과하는 경우, 앞에서부터 11자리만 취함
        let trimmedAmount = String(filteredAmount.prefix(11))

        // CurrencyManager에 따라 Double 또는 Int로 처리
        if CurrencyManager.shared.hasDecimalPoint {
            guard let value = Double(trimmedAmount) else { return "" }
            return formatAmount(value)
        } else {
            guard let value = Int(trimmedAmount) else { return "" }
            return formatAmount(value)
        }
    }

    func formatAmount(_ value: Any) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = CurrencyManager.shared.hasDecimalPoint ? 0 : 2

        if let doubleValue = value as? Double {
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? ""
        } else if let intValue = value as? Int {
            return numberFormatter.string(from: NSNumber(value: intValue)) ?? ""
        } else {
            return ""
        }
    }
     
     
}

