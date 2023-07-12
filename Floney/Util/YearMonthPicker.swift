//
//  YearMonthPicker.swift
//  Floney
//
//  Created by 남경민 on 2023/07/13.
//

import Foundation
import SwiftUI

struct YearMonthPicker: UIViewRepresentable {
    let selection: Binding<YearMonthDuration>
    let years: [Int]
    let months: [Int]
    
    func makeUIView(context: Context) -> UIPickerView {
        let pickerView = UIPickerView(frame: .zero)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = context.coordinator
        pickerView.dataSource = context.coordinator
        return pickerView
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        let yearIndex = years.firstIndex(of: selection.wrappedValue.year) ?? 0
        let monthIndex = months.firstIndex(of: selection.wrappedValue.month) ?? 0
        uiView.selectRow(yearIndex, inComponent: 0, animated: true)
        uiView.selectRow(monthIndex, inComponent: 1, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selection: selection, years: years, months: months)
    }
    
    
    final class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
      
        let selection: Binding<YearMonthDuration>
        let years: [Int]
        let months: [Int]
        
        init(selection: Binding<YearMonthDuration>,
             years: [Int],
             months: [Int]) {
            self.selection = selection
            self.years = years
            self.months = months
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return component == 0 ? years.count : months.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return "\(years[row])"
            }
            else {
                return "\(months[row])"
                
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let yearIndex = pickerView.selectedRow(inComponent: 0)
            let monthIndex = pickerView.selectedRow(inComponent: 1)
            selection.wrappedValue = YearMonthDuration(year: years[yearIndex], month: months[monthIndex])
        }
    }
    
}


