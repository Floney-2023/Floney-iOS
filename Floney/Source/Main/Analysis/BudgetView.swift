//
//  BudgetView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct BudgetView: View {
    @State private var progress: Double = 50 // 50%
    
    var body: some View {
        VStack {
            VStack(alignment:.leading, spacing: 0){
                Text("현재 예산의")
                    .font(.pretendardFont(.bold,size: 22))
                    .foregroundColor(.greyScale1)
                    .padding(.bottom,10)
                HStack{
                    VStack(alignment:.leading, spacing: 10) {
                        Text("60%를 사용했어요")
                            .font(.pretendardFont(.bold,size: 22))
                            .foregroundColor(.greyScale1)
                        Text("남은 기간동안 하루에\n40,0000원을 사용할 수 있어요")
                            .font(.pretendardFont(.medium,size: 13))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                    Image("budget")
                }
            }.padding(.bottom, 42)
                .padding(.horizontal, 24)
        
            ZStack {
                
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(Color.greyScale10, style: StrokeStyle(lineWidth: 20, lineCap: .round)) // Here
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-180))
                    .padding()
                
                Circle()
                    .trim(from: 0.0, to: 0.6 * 0.5) // Adjust the completion to fill half of the circle
                    .stroke(Color.primary1, style: StrokeStyle(lineWidth: 20, lineCap: .round)) // .round option makes the line ends rounded
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-180))
                    .padding()
                VStack(spacing:-10) {
                    Image("img_budget_50~79")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100) // Adjust the size as needed
                        .offset(y: -20) // Move the image up
                    VStack {
                        Text("조금씩 지출을")
                        Text("줄여볼까요?")
                    }
                }
                .font(.pretendardFont(.medium, size: 12))
                .foregroundColor(.greyScale7)
            }
        
            
            HStack() {
                VStack(alignment: .leading,spacing: 12) {
                    Text("남은 금액")
                        .font(.pretendardFont(.medium, size: 14))
                        .foregroundColor(.greyScale6)
                    Text("400,000원")
                        .font(.pretendardFont(.bold, size: 20))
                        .foregroundColor(.greyScale2)
                }.frame(maxWidth: .infinity)
                    
                VStack(alignment: .leading,spacing: 12) {
                    Text("총 예산")
                        .font(.pretendardFont(.medium, size: 14))
                        .foregroundColor(.greyScale6)
                    Text("1,000,000원")
                        .font(.pretendardFont(.bold, size: 20))
                        .foregroundColor(.greyScale2)
                }.frame(maxWidth: .infinity)
            }//.padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                
            
            
            Spacer()
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
        BudgetView()
    }
}