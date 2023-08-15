//
//  AssetView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct AssetView: View {
    @ObservedObject var viewModel : AnalysisViewModel
    /*
    var assetData: [AssetData] = [
        AssetData(month: "6", amount: 500000.0),
        AssetData(month: "7", amount: 4000.0),
        AssetData(month: "8", amount: 6000.0),
        AssetData(month: "9", amount: 3000.0),
        AssetData(month: "10", amount: 6500.0),
        AssetData(month: "이번달", amount: 4800000.0)
        
    ]*/
    //var standardizedData : [AssetData]?
    //var normalizedData : [AssetData]?
   
    var body: some View {
        // Log Transform the asset data
        //let logTransformedData = assetData.map { AssetData(month: $0.month, amount: log($0.amount)) }
        // Get the min and max of the log transformed data
        //let minLogAmount = logTransformedData.map { $0.amount }.min() ?? 0
        //let maxLogAmount = logTransformedData.map { $0.amount }.max() ?? 1
       
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
                            Text("지난달 대비 \(viewModel.difference)원\n증가했어요")
                                .font(.pretendardFont(.medium,size: 13))
                                .foregroundColor(.greyScale6)
                        }
                        Spacer()
                        Image("asset")
                    }
                }
                .padding(.horizontal, 24)
                /*
                HStack(alignment: .bottom, spacing: 40) {
                    ForEach(assetData.indices) { index in
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(index == self.assetData.count - 1 ? Color.primary1 : Color.greyScale10)
                                .frame(width: 20, height: CGFloat(self.assetData[index].amount) / 200.0)
                            Text("\(self.assetData[index].month)")
                                .font(.pretendardFont(.medium, size: 12))
                                .foregroundColor(.greyScale6)
                        }
                    }
                    
                }.frame(height: 200)*/
                HStack(alignment: .bottom, spacing: 40) {
                    if viewModel.assetList.count == 0 {
                        Text("다시 확인")
                            .font(.system(size: 12))
                    } else {
                        ForEach(viewModel.assetList.indices) { index in
                            VStack {
                                Spacer()
                                Rectangle()
                                    .fill(index == viewModel.assetList.count - 1 ? Color.primary1 : Color.greyScale10)
                                    .frame(width: 20, height: CGFloat(((viewModel.assetList[index].currentAsset - 0) / (log(9999999999) - 0) * 200.0)) + 4)
                                Text("\(viewModel.assetList[index].month!)")
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }.frame(height: 200)
                
                VStack(alignment: .leading, spacing: 42) {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("현재자산")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale6)
                            Text("\(viewModel.currentAsset)원")
                                .font(.pretendardFont(.bold, size: 20))
                                .foregroundColor(.greyScale2)
                        }
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("초기자산")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale6)
                        Text("\(viewModel.initAsset)원")
                            .font(.pretendardFont(.bold, size: 20))
                            .foregroundColor(.greyScale2)
                    }
                }
                .padding(.horizontal, 24)
                Spacer()
            }
            onAppear{
                viewModel.initAssetList()
                let dates = viewModel.calculateAssetMonth()
                for date in dates {
                    viewModel.analysisAsset(date: date)
                }
            }
            .onChange(of: viewModel.selectedDate) { newValue in
                viewModel.initAssetList()
                let dates = viewModel.calculateAssetMonth()
                for date in dates {
                    viewModel.analysisAsset(date: date)
                }
            }
            
        }
        
    }
}

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        AssetView(viewModel: AnalysisViewModel())
    }
}
