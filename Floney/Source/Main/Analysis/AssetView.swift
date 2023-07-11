//
//  AssetView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct AssetView: View {
    var assetData: [AssetData] = [
            AssetData(month: "6", amount: 5000),
            AssetData(month: "7", amount: 4000),
            AssetData(month: "8", amount: 6000),
            AssetData(month: "9", amount: 3000),
            AssetData(month: "10", amount: 6500),
            AssetData(month: "이번달", amount: 4800)
        ]
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 42) {
                VStack(alignment:.leading, spacing: 0){
                    Text("나의 자산이")
                        .font(.pretendardFont(.bold,size: 22))
                        .foregroundColor(.greyScale1)
                    HStack{
                        VStack(alignment:.leading, spacing: 10) {
                            Text("지난달보다 증가했어요")
                                .font(.pretendardFont(.bold,size: 22))
                                .foregroundColor(.greyScale1)
                            Text("지난달 대비 100,000원\n증가했어요")
                                .font(.pretendardFont(.medium,size: 13))
                                .foregroundColor(.greyScale6)
                        }
                        Spacer()
                        Image("asset")
                    }
                }
                .padding(.horizontal, 24)
                
                HStack(alignment: .bottom, spacing: 40) {
                    ForEach(assetData.indices) { index in
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(index == self.assetData.count - 1 ? Color.primary1 : Color.greyScale10)
                                .frame(width: 20, height: CGFloat(self.assetData[index].amount) / 1000.0)
                            Text("\(self.assetData[index].month)")
                                .font(.pretendardFont(.medium, size: 12))
                                .foregroundColor(.greyScale6)
                        }
                    }
                }.frame(height: 200)
                
                VStack(alignment: .leading, spacing: 42) {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("현재자산")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale6)
                            Text("1,100,000원")
                                .font(.pretendardFont(.bold, size: 20))
                                .foregroundColor(.greyScale2)
                        }
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Text("초기자산")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale6)
                        Text("1,000,000원")
                            .font(.pretendardFont(.bold, size: 20))
                            .foregroundColor(.greyScale2)
                    }
                    
                    
                    
                }
                .padding(.horizontal, 24)
                
                
                Spacer()
            }
        }
        
    }
}

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        AssetView()
    }
}
