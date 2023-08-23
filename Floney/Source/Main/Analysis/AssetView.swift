//
//  AssetView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct AssetView: View {
    @ObservedObject var viewModel : AnalysisViewModel
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
                            Text("지난달 대비 \(viewModel.difference)원\n증가했어요")
                                .font(.pretendardFont(.medium,size: 13))
                                .foregroundColor(.greyScale6)
                        }
                        Spacer()
                        Image("asset")
                    }
                }
                .padding(.horizontal, 24)

                HStack(alignment: .bottom, spacing: 40) {
                    if viewModel.assetList.isEmpty {
                        Text("다시 확인")
                            .font(.system(size: 12))
                    } else {
                        let maxAsset = viewModel.assetList.map { $0.currentAsset }.max() ?? 1.0
                        ForEach(viewModel.assetList.indices) { index in
                            VStack {
                                Spacer()
                                Rectangle()
                                    .fill(index == viewModel.assetList.count - 1 ? Color.primary1 : Color.greyScale10)
                                    .frame(width: 20, height: CGFloat((viewModel.assetList[index].currentAsset / maxAsset) * 200.0) + 4)
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
