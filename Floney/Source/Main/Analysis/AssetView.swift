//
//  AssetView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct AssetView: View {
    let scaler = Scaler.shared
    @ObservedObject var viewModel : AnalysisViewModel
    @State var currency = CurrencyManager.shared.currentCurrency
    var body: some View {
        VStack(spacing: 42) {
            HStack{
                VStack(alignment:.leading, spacing: scaler.scaleHeight(8)){
                    if viewModel.difference > 0 {
                        Text("나의 자산이\n지난달보다 증가했어요")
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(22)))
                            .lineSpacing(10)
                            .foregroundColor(.greyScale1)
                        
                        Text("지난달 대비 \(Int(viewModel.difference))\(currency)\n증가했어요")
                            .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                    } else if viewModel.difference < 0 {
                        Text("나의 자산이\n지난달보다 감소했어요")
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(22)))
                            .lineSpacing(10)
                            .foregroundColor(.greyScale1)
                        
                        Text("지난달 대비 \(Int(abs(viewModel.difference)))\(currency)\n감소했어요")
                            .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                    } else {
                        Text("나의 자산이\n지난달과 같아요")
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(22)))
                            .lineSpacing(10)
                            .foregroundColor(.greyScale1)
                        
                        Text("지난달 대비 0\(currency)\n증가했어요")
                            .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                        
                    }
                    
                }
                Spacer()
                VStack {
                    Spacer()
                    if viewModel.difference > 0 {
                        Image("asset")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: scaler.scaleWidth(80),height: scaler.scaleWidth(90))
                 
                    } else if viewModel.difference < 0 {
                        Image("asset_decreased")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: scaler.scaleWidth(80),height: scaler.scaleWidth(70))
                 
                    } else {
                        Image("asset")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: scaler.scaleWidth(80),height: scaler.scaleWidth(90))
                   
                    }
                }
                
            }
            .frame(height: scaler.scaleHeight(110))
            .padding(.horizontal, scaler.scaleWidth(4))
            
            
            HStack(alignment: .bottom, spacing: scaler.scaleWidth(30)) {
                if viewModel.assetList.count == 6 {
                    // assetList를 month 기준으로 정렬합니다.
                    let maxAsset = viewModel.assetList.map { $0.currentAsset }.max() ?? 1.0
                    let minHeight: CGFloat = scaler.scaleHeight(4.0)
                    let maxHeight: CGFloat = scaler.scaleHeight(146.0)
                    
                    ForEach(viewModel.assetList.indices) { index in
                        VStack {
                            Spacer()
                            let assetValue = viewModel.assetList[index].currentAsset
                            let barHeight: CGFloat = assetValue <= 0 ? minHeight : (maxHeight - minHeight) * CGFloat(assetValue / maxAsset) + minHeight
                            Rectangle()
                                .fill(index == viewModel.assetList.count - 1 ? Color.primary1 : Color.greyScale10)
                                .frame(width: scaler.scaleWidth(20), height: barHeight)
                                .cornerRadius(4)
                            //index == viewModel.assetList.count - 1 ? "이번달" :
                            Text("\(viewModel.assetList[index].month!)")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                .foregroundColor(.greyScale6)
                        }
                    }
                } else {
                    
                }
            }.frame(height:scaler.scaleHeight(146))
            
            VStack(alignment: .leading, spacing: scaler.scaleHeight(42)) {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(12)) {
                        Text("현재자산")
                            .font(.pretendardFont(.medium, size:scaler.scaleWidth(14)))
                            .foregroundColor(.greyScale6)
                        Text("\(Int(viewModel.currentAsset))\(currency)")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(20)))
                            .foregroundColor(.greyScale2)
                    }
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: scaler.scaleHeight(12)) {
                    Text("초기자산")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale6)
                    Text("\(Int(viewModel.initAsset))\(currency)")
                        .font(.pretendardFont(.bold, size: scaler.scaleWidth(20)))
                        .foregroundColor(.greyScale2)
                }
            }.padding(.horizontal, scaler.scaleWidth(4))
            
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

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        AssetView(viewModel: AnalysisViewModel())
    }
}
