//
//  CalendarView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/13.
//

import SwiftUI

struct CalendarView: View {
    let month: Date
    @StateObject var viewModel = CalendarViewModel()

    var body: some View {
        VStack {
            HStack {
                Text("\(viewModel.selectedYear)")
                Text("\(viewModel.selectedMonth)")
                    .onTapGesture {
                        viewModel.nextMonth()
                    }
            }
            .font(.largeTitle)
            .padding()

            // Display the days of the month here
            ForEach(viewModel.monthlyData, id: \.date) { data in
                HStack {
                    Text(data.date)
                    Spacer()
                    if (data.assetType == "INCOME"){
                        Text("Income: \(data.money)")
                    } else {
                        Text("Outcome: \(data.money)")
                    }
                }
                .background(data.date == viewModel.selectedDate?.date ? Color.blue : Color.clear)
                .onTapGesture {
                    viewModel.selectDate(data)
                }
            }
            
            // Show BottomSheetView when a date is selected
            if let selectedDate = viewModel.selectedDate {
                BottomSheetView(data: selectedDate)
            }
        }
    }
}
struct BottomSheetView: View {
    let data: CalendarExpenses

    var body: some View {
        VStack {
            Text("Details for \(data.date)")
            Text("Income: \(data.money)")
            Text("Outcome: \(data.money)")
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(month: Date())
    }
}
