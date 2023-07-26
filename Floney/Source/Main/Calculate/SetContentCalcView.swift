//
//  SetContentCalc.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI

struct SetContentCalcView: View {
    @Binding var isShowingTabbar : Bool
    @Binding var isShowingCalc : Bool
   // @Binding var isShowingPeriod : Bool
    //@Binding var isShowingContent : Bool
    //@State var isShowingComplete = false
    
    @ObservedObject var viewModel : CalculateViewModel
    /*
    @State var list : [SettlementResponse] = [
    SettlementResponse(money: 6000, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "Cake", img: nil),
    SettlementResponse(money: 4500, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "커피", img: nil)
    ]*/
    @Binding var pageCount : Int
    var pageCountAll = 4
    
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    Spacer()
                    Image("icon_close")
                        .padding(.trailing, 24)
                        .onTapGesture {
                            self.isShowingTabbar = true
                            self.isShowingCalc = false
                        }
                }
                VStack(spacing: 32) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(pageCount)")
                                .foregroundColor(.greyScale2)
                                .font(.pretendardFont(.medium, size: 12))
                            + Text(" / \(pageCountAll)")
                                .foregroundColor(.greyScale6)
                                .font(.pretendardFont(.medium, size: 12))
                            
                            
                            Text("정산할 내역을")
                                .font(.pretendardFont(.bold, size: 22))
                                .foregroundColor(.greyScale1)
                                .padding(.top, 11)
                            Text("선택해주세요")
                                .font(.pretendardFont(.bold, size: 22))
                                .foregroundColor(.greyScale1)
                        }
                        
                        
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("전체선택")
                            .font(.pretendardFont(.regular,size: 12))
                            .foregroundColor(.greyScale8)
                    }
                    VStack {
                        ForEach(viewModel.lines.indices, id: \.self) { index in
                            HStack {
                                if viewModel.lines[index].isSelected! {
                                    Image("icon_check_circle_activated")
                                        .padding(.bottom, 15)
                                }
                                else {
                                    Image("icon_check_circle_disabled")
                                        .padding(.bottom, 15)
                                }
                                VStack {
                                    
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("\(viewModel.lines[index].content)")
                                                .font(.pretendardFont(.medium, size: 14))
                                                .foregroundColor(.greyScale2)
                                            Text("\(viewModel.lines[index].category[0]) ‧ \(viewModel.lines[index].category[1])")
                                                .font(.pretendardFont(.medium, size: 12))
                                                .foregroundColor(.greyScale6)
                                        }
                                        Spacer()
                                        Text("\(Int(viewModel.lines[index].money))원")
                                            .font(.pretendardFont(.medium, size: 14))
                                            .foregroundColor(.greyScale2)
                                    }.padding(.bottom, 8)
                                    
                                    Divider()
                                    
                                }
                            }.frame(height: 55)
                                .onTapGesture {
                                    viewModel.lines[index].isSelected?.toggle()
                                }
                        }
                    }
                    
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
                HStack(spacing:0){
                    
                    Text("이전으로")
                        .padding()
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.greyScale2)
                        .onTapGesture {
                            //self.isShowingContent = false
                            pageCount = 2
                        }
                    Text("정산하기")
                        .padding()
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(width: UIScreen.main.bounds.width * 2/3)
                        .background(Color.primary1)
                        .onTapGesture {
                            viewModel.CheckOutcome()
                            viewModel.postSettlements()
                            pageCount = 4 
                        }
                }
                
            }
            .onAppear{
                
            }
  
        }

    }

}

struct SetContentCalcView_Previews: PreviewProvider {
    static var previews: some View {
        SetContentCalcView(isShowingTabbar: .constant(false), isShowingCalc: .constant(true),viewModel: CalculateViewModel(), pageCount: .constant(3))
    }
}
