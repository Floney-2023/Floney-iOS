//
//  BudgetView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct BudgetView: View {
    let scaler = Scaler.shared
    @Binding var showingTabbar : Bool
    @State private var progress: Double = 50 // 50%
    @ObservedObject var viewModel : AnalysisViewModel
    @State var currency = CurrencyManager.shared.currentCurrency
    @State var isActive = false
    var body: some View {
        Group {
            if viewModel.totalBudget > 0 {
                VStack {
                    HStack{
                        VStack(alignment:.leading, spacing: scaler.scaleHeight(8)){
                            Text("현재 예산의\n\(Int(viewModel.budgetPercentage))%를 사용했어요")
                                .font(.pretendardFont(.bold,size:scaler.scaleWidth(22)))
                                .lineSpacing(10)
                                .foregroundColor(.greyScale1)
                            
                            let calendar = Calendar.current
                            let today = Date()
                            let currentYear = calendar.component(.year, from: today)
                            let currentMonth = calendar.component(.month, from: today)
                            
                            let selectedYear = calendar.component(.year, from: viewModel.selectedDate)
                            let selectedMonth = calendar.component(.month, from: viewModel.selectedDate)
                            if currentYear <= selectedYear && currentMonth <= selectedMonth {
                                Text("남은 기간동안 하루에\n\(Int(viewModel.dailyAvailableMoney))\(currency)을 사용할 수 있어요")
                                    .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                    .foregroundColor(.greyScale6)
                            } else {
                                Text("이미 지나간 달에는\n하루 예산이 표시되지 않아요.")
                                    .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                    .foregroundColor(.greyScale6)
                            }
                            
                        }
                        Spacer()
                        
                        Image("budget")
                            .resizable()
                            .frame(width: scaler.scaleWidth(80),height: scaler.scaleWidth(52))
                        
                        
                    }
                    .frame(height: scaler.scaleHeight(110))
                    .padding(.horizontal, scaler.scaleWidth(4))
                    
                    ZStack {
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .stroke(Color.greyScale10, style: StrokeStyle(lineWidth: 20, lineCap: .round)) // Here
                            .frame(width: scaler.scaleWidth(220), height: scaler.scaleWidth(220))
                            .rotationEffect(.degrees(-180))
                            .padding()
                        
                        Circle()
                            .trim(from: 0.0, to: viewModel.budgetRatio * 0.5) // Adjust the completion to fill half of the circle
                            .stroke(Color.primary1, style: StrokeStyle(lineWidth: 20, lineCap: .round)) // .round option makes the line ends rounded
                            .frame(width: scaler.scaleWidth(220), height: scaler.scaleWidth(220))
                            .rotationEffect(.degrees(-180))
                            .padding()
                        
                        VStack(spacing:scaler.scaleHeight(-10)) {
                            switch viewModel.budgetPercentage {
                            case 0..<50 :
                                Image("img_budget_0~49")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: scaler.scaleWidth(50), height: scaler.scaleWidth(84))
                                    .offset(y: scaler.scaleHeight(-20)) // Move the image up
                                VStack {
                                    Text("쓸 수 있는 예산이")
                                    Text("충분해요!")
                                    
                                }
                                
                            case 50..<80 :
                                Image("img_budget_50~79")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: scaler.scaleWidth(50), height: scaler.scaleWidth(84))
                                    .offset(y: scaler.scaleHeight(-20))
                                VStack {
                                    Text("조금씩 지출을")
                                    Text("줄여볼까요?")
                                }
                                
                            case 80...100 :
                                Image("img_budget_80~99")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: scaler.scaleWidth(50), height: scaler.scaleWidth(84))
                                    .offset(y: scaler.scaleHeight(-20))
                                VStack {
                                    Text("예산을 넘기지 않게")
                                    Text("주의하세요!")
                                }
                                
                            default:
                                Image("img_budget_0")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: scaler.scaleWidth(50), height: scaler.scaleWidth(84))
                                    .offset(y: scaler.scaleHeight(-20))
                                VStack {
                                    Text("예산을")
                                    Text("사용하지 않았어요.")
                                }
                            }
                        }
                        .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                        .foregroundColor(.greyScale7)
                    }
                    .frame(width: scaler.scaleWidth(220), height:scaler.scaleWidth(220))
                    .padding(.top, scaler.scaleHeight(42))
                    
                    HStack(spacing:scaler.scaleWidth(16)) {
                        HStack {
                            VStack(alignment: .leading,spacing: scaler.scaleHeight(12)) {
                                Text("남은 금액")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale6)
                                Text("\(Int(viewModel.leftBudget))\(currency)")
                                    .font(.pretendardFont(.bold, size: scaler.scaleWidth(20)))
                                    .foregroundColor(.greyScale2)
                            }
                            Spacer()
                        }
                        HStack {
                            VStack(alignment: .leading,spacing: scaler.scaleHeight(12)){
                                Text("총 예산")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale6)
                                Text("\(Int(viewModel.totalBudget))\(currency)")
                                    .font(.pretendardFont(.bold, size: scaler.scaleWidth(20)))
                                    .foregroundColor(.greyScale2)
                            }
                            Spacer()
                        }
                    }
                    .frame(width: scaler.scaleWidth(312))
                    .padding(.horizontal, scaler.scaleWidth(4))
                    Spacer()
                }
                // 예산 설정을 하지 않음
            } else {
                VStack(spacing:0) {
                    ZStack {
                        HStack{
                            VStack(alignment:.leading, spacing: scaler.scaleHeight(8)){
                                Text("현재 예산의\n0%를 사용했어요")
                                    .font(.pretendardFont(.bold,size:scaler.scaleWidth(22)))
                                    .lineSpacing(10)
                                    .foregroundColor(.greyScale1)
                                
                                let calendar = Calendar.current
                                let today = Date()
                                let currentYear = calendar.component(.year, from: today)
                                let currentMonth = calendar.component(.month, from: today)
                                
                                let selectedYear = calendar.component(.year, from: viewModel.selectedDate)
                                let selectedMonth = calendar.component(.month, from: viewModel.selectedDate)
                                if currentYear <= selectedYear && currentMonth <= selectedMonth {
                                    Text("남은 기간동안 하루에\n\(Int(viewModel.dailyAvailableMoney))\(currency)을 사용할 수 있어요")
                                        .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                        .foregroundColor(.greyScale6)
                                } else {
                                    Text("이미 지나간 달에는\n하루 예산이 표시되지 않아요.")
                                        .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                        .foregroundColor(.greyScale6)
                                }
                                
                            }
                            Spacer()
                            Image("budget")
                                .resizable()
                                .frame(width: scaler.scaleWidth(80),height: scaler.scaleWidth(52))
                        }
                        Color.white
                            .opacity(0.9)
                    }
                    .frame(height: scaler.scaleHeight(110))
                    .padding(.horizontal, scaler.scaleWidth(4))
                    
                    ZStack {
                        Circle()
                            .trim(from: 0.0, to: 0.5)
                            .stroke(Color.greyScale10, style: StrokeStyle(lineWidth: 20, lineCap: .round)) // Here
                            .frame(width: scaler.scaleWidth(220), height: scaler.scaleWidth(220))
                            .rotationEffect(.degrees(-180))
                            .padding()
                        
                        Circle()
                            .trim(from: 0.0, to: 0.0) // Adjust the completion to fill half of the circle
                            .stroke(Color.primary1, style: StrokeStyle(lineWidth: 20, lineCap: .round)) // .round option makes the line ends rounded
                            .frame(width: scaler.scaleWidth(220), height: scaler.scaleWidth(220))
                            .rotationEffect(.degrees(-180))
                            .padding()
                        
                        
                        VStack(spacing:scaler.scaleHeight(-10)) {
                            Image("img_budget_0~49")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: scaler.scaleWidth(50), height: scaler.scaleWidth(84))
                                .offset(y: scaler.scaleHeight(-20)) // Move the image up
                            VStack {
                                Text("예산을")
                                Text("설정하고 체계적인 소비 습관을 만들어 보세요!")
                            }
                        }
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                        .foregroundColor(.greyScale7)
                    }
                    .frame(width: scaler.scaleWidth(220), height:scaler.scaleWidth(220))
                    .padding(.top, scaler.scaleHeight(42))
                    
                    ZStack {
                        HStack(spacing:scaler.scaleWidth(16)) {
                            HStack {
                                VStack(alignment: .leading,spacing: scaler.scaleHeight(12)) {
                                    Text("남은 금액")
                                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                        .foregroundColor(.greyScale6)
                                }
                                Spacer()
                            }
                            HStack {
                                VStack(alignment: .leading,spacing: scaler.scaleHeight(12)){
                                    Text("총 예산")
                                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                        .foregroundColor(.greyScale6)
                                    
                                }
                                Spacer()
                            }
                        }
                        .frame(width: scaler.scaleWidth(312))
                        .frame(height: scaler.scaleHeight(14))
                        .padding(.horizontal, scaler.scaleWidth(4))
                        Color.white
                            .opacity(0.9)
                    }
                    .frame(height: scaler.scaleHeight(14))
                    .padding(.bottom, scaler.scaleHeight(14))
                    
                    NavigationLink(destination: SetBudgetView(), isActive : $isActive) {
                        Button {
                            isActive = true
                        } label: {
                            Text("이번달 예산 설정하기")
                                .padding(scaler.scaleHeight(16))
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.primary1)
                        .cornerRadius(12)
                    }
                    Spacer()
                }
                
            }
        }
        .onAppear{
            viewModel.analysisBudget()
        }
        .onChange(of: viewModel.selectedDate) { newValue in
            viewModel.analysisBudget()
        }
    }
}
struct DonutSegment: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.width, rect.height)
        let radius = diameter / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        var path = Path()
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addArc(center: center, radius: radius/2, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.closeSubpath()
        
        return path
    }
}
struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView(showingTabbar: .constant(true), viewModel: AnalysisViewModel())
    }
}
