//
//  NotificationView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/23.
//

import SwiftUI

struct NotificationView: View {
    @Binding var showingTabbar : Bool
    //@State var title = "가계부 알림"
    @State private var selectedTab = 0
    @GestureState private var translation: CGFloat = 0
    
    @State var bookName = "도토리의농장"
    var body: some View {
        
        VStack {
            // Tab Selection
            HStack {
                ForEach(0..<2) { index in
                    Button(action: {
                        withAnimation {
                            selectedTab = index
                        }
                    }) {
                        VStack {
                            Text("가계부\(index+1)")
                            Rectangle()
                                .fill(selectedTab == index ? Color.primary1 : Color.background2)
                                .frame(height: 4) // Adjust thickness here
                                .cornerRadius(20)
                                
                        }
                    }
                    //.padding()
                    .font(.pretendardFont(.medium,size: 14))
                    //.background(selectedTab == index ? Color.blue : Color.clear)
                    .foregroundColor(selectedTab == index ? .greyScale2 : .greyScale8)
                    //.cornerRadius(10)
                }
            }
            .padding(.top,32)
            .padding(.horizontal,20)
            .padding(.bottom,14)

            // Content
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(0..<2) { index in
                        VStack {
                            //Text("가계부 \(index+1) 알림")
                            HStack(spacing:16) {
                                Image("noti_settlement")
                                    .padding(.leading, 20)
                                    .padding(.vertical, 20)
                                VStack(alignment: .leading, spacing:5) {
                                    Text("team의 가계부를 정산해보세요.")
                                        .font(.pretendardFont(.regular, size: 14))
                                        .foregroundColor(.greyScale2)
                                    Text("1시간전")
                                        .font(.pretendardFont(.regular, size: 14))
                                        .foregroundColor(.greyScale8)
                                }
                                Spacer()
                            }
                            
                            .background(Color.primary10)
                            .cornerRadius(12)
                            Spacer()
                        }
                        .padding(.horizontal,20)
                        .frame(width: geometry.size.width)
                        .background(Color.white)
                    }
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(selectedTab) * geometry.size.width)
                .offset(x: translation)
                .animation(.spring(), value: selectedTab)
                .gesture(
                    DragGesture()
                        .updating($translation) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            let offset = value.translation.width / geometry.size.width
                            let newIndex = (CGFloat(selectedTab) - offset).rounded()
                            selectedTab = min(max(Int(newIndex), 0), 1)
                        }
                )
            }
        }
        .customNavigationBar(
            leftView: { BackButtonBlack() },
            centerView: {
                Text("가계부 알림")
                .font(.pretendardFont(.semiBold, size: 16))
                .foregroundColor(.greyScale1)}
            
            )
        .onAppear{
            showingTabbar = false
        }
    }
        
}


struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(showingTabbar: .constant(false))
    }
}
