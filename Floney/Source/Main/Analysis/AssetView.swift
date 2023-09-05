//
//  AssetView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct AssetView: View {
    @ObservedObject var viewModel : AnalysisViewModel
    @State var currency = CurrencyManager.shared.currentCurrency
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 42) {
                VStack(alignment:.leading, spacing: 0){
                    Text("나의 자산이")
                        .font(.pretendardFont(.bold,size: 22))
                        .foregroundColor(.greyScale1)
                    HStack{
                        if viewModel.difference > 0 {
                            VStack(alignment:.leading, spacing: 10) {
        
                                Text("지난달보다 증가했어요")
                                    .font(.pretendardFont(.bold,size: 22))
                                    .foregroundColor(.greyScale1)
                                Text("지난달 대비 \(Int(viewModel.difference))\(currency)\n증가했어요")
                                    .font(.pretendardFont(.medium,size: 13))
                                    .foregroundColor(.greyScale6)
                                
                            }
                            Spacer()
                            Image("asset")
                        } else if viewModel.difference < 0 {
                            VStack(alignment:.leading, spacing: 10) {
                                Text("지난달보다 감소했어요")
                                    .font(.pretendardFont(.bold,size: 22))
                                    .foregroundColor(.greyScale1)
                                Text("지난달 대비 \(Int(abs(viewModel.difference)))\(currency)\n감소했어요")
                                    .font(.pretendardFont(.medium,size: 13))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            Image("asset_decreased")
                        } else {
                            VStack(alignment:.leading, spacing: 10) {
                                Text("지난달과 같아요")
                                    .font(.pretendardFont(.bold,size: 22))
                                    .foregroundColor(.greyScale1)
                                Text("지난달 대비 0\(currency)\n증가했어요")
                                    .font(.pretendardFont(.medium,size: 13))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            Image("asset")
                        }
                        
                    }
                }
                //.padding(.horizontal, 24)

                HStack(alignment: .bottom, spacing: 40) {
                    if viewModel.assetList.count == 6 {
                        // assetList를 month 기준으로 정렬합니다.
                        let maxAsset = viewModel.assetList.map { $0.currentAsset }.max() ?? 1.0
                        let minHeight: CGFloat = 4.0
                        let maxHeight: CGFloat = 200.0

                        ForEach(viewModel.assetList.indices) { index in
                            VStack {
                                Spacer()
                                let assetValue = viewModel.assetList[index].currentAsset
                                let barHeight: CGFloat = assetValue <= 0 ? minHeight : (maxHeight - minHeight) * CGFloat(assetValue / maxAsset) + minHeight
                                Rectangle()
                                    .fill(index == viewModel.assetList.count - 1 ? Color.primary1 : Color.greyScale10)
                                    .frame(width: 20, height: barHeight)
                                    .cornerRadius(4)
                                //index == viewModel.assetList.count - 1 ? "이번달" :
                                Text("\(viewModel.assetList[index].month!)")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale6)
                            }
                        }
                    } else {
                        Text("다시 확인")
                            .font(.system(size: 12))
                    }
                }.frame(height: 200)
                
                VStack(alignment: .leading, spacing: 42) {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("현재자산")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale6)
                            Text("\(Int(viewModel.currentAsset))\(currency)")
                                .font(.pretendardFont(.bold, size: 20))
                                .foregroundColor(.greyScale2)
                        }
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("초기자산")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale6)
                        Text("\(Int(viewModel.initAsset))\(currency)")
                            .font(.pretendardFont(.bold, size: 20))
                            .foregroundColor(.greyScale2)
                    }
                }
                
                Spacer()
            }
            .onAppear{
                print("in asset view selectedDate : \(viewModel.selectedDate)")
             
                viewModel.calculateAssetMonth()
               
            }
            .onChange(of: viewModel.selectedDate) { newValue in
                print("in asset view selectedDate : \(viewModel.selectedDate)")
       
                viewModel.calculateAssetMonth()
                
            }
        }
        
    }
}

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        AssetView(viewModel: AnalysisViewModel())
    }
}
