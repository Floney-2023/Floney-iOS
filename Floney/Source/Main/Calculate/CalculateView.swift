//
//  CalculateView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct CalculateView: View {
    var date = 11
    @State var isShowingCalc = false
    @Binding var showingTabbar : Bool
    
    var body: some View {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("정산")
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                            .padding(.bottom, 34)
                        
                        Text("마지막 정산일로부터\n\(date)일 지났어요")
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                            .padding(.bottom, 10)
                        
                        Text("복잡하고 어려운 정산, 저희가 대신 해드릴게요")
                            .font(.pretendardFont(.medium, size: 13))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Image("calculate")
                    .padding(.bottom, 36)
                
                Button {
                    self.isShowingCalc = true
                } label: {
                    Text("정산하기")
                }
                .frame(height: 46)
                .modifier(NextButtonModifier(backgroundColor: .primary1))
                .padding()
                .padding(.bottom, 5)
                
                
                VStack {
                    Text("정산 내역 보기")
                        .font(.pretendardFont(.regular, size: 12))
                        .foregroundColor(.greyScale6)
                    Divider()
                        .frame(width: 70,height: 1.0)
                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                        .foregroundColor(.greyScale6)
                }
                .onTapGesture {
                    
                }
                Spacer()
                
                NavigationLink(destination : CalculateMainView(isShowingTabbar: $showingTabbar, isShowingCalc: $isShowingCalc), isActive: $isShowingCalc){
                    EmptyView()
                }
            }.padding(.top, 26)
            
            
        
    }
}

struct CalculateView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateView(showingTabbar: .constant(true))
    }
}
