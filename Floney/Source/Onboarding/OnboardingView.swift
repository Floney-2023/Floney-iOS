//
//  OnboardingView.swift
//  Floney
//
//  Created by 남경민 on 2023/09/02.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedPageIndex = 0

    var body: some View {
        VStack {
            PageDotsView(numberOfPages: 3, currentPage: $selectedPageIndex)
                .padding(.top, 82)
                .padding(.bottom, 16)
                .padding(.leading, 24)
            TabView(selection: $selectedPageIndex) {
                VStack(spacing:32) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("함께, 간편하게")
                            Text("가계부를 기록해 보세요")
                        }
                        .padding(.leading, 24)
                        Spacer()
                    }
                    Image("onboarding_1")
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .greyScale10,radius: 10)
                    Spacer()
                }
                .foregroundColor(.greyScale1)
                .font(.pretendardFont(.bold, size: 24))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //.background(Color.red)
                .tag(0)
                
                VStack(spacing:32) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("모으고 사용한 흐름을")
                            Text("한눈에 볼 수 있어요")
                        }
                        .padding(.leading, 24)
                        Spacer()
                    }
                    Image("onboarding_2")
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .greyScale10,radius: 10)

                    Spacer()
                }
                .foregroundColor(.greyScale1)
                .font(.pretendardFont(.bold, size: 24))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //.background(Color.green)
                .tag(1)
                
                VStack(spacing:32) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("기록한 내역으로")
                            Text("손쉽게 정산할 수 있어요")
                        }
                        .padding(.leading, 24)
                        Spacer()
                    }
                    Image("onboarding_3")
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .greyScale10,radius: 10)
                        
                    Spacer()
                }
                .foregroundColor(.greyScale1)
                .font(.pretendardFont(.bold, size: 24))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //.background(Color.blue)
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            if selectedPageIndex == 2 {
                Button {
                    
                } label: {
                    Text("플로니 시작하기")
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.primary1)
                .cornerRadius(12)
                .padding(.horizontal,20)
                .padding(.bottom, 38)
                
            } else {
                VStack {
                    Text("건너뛰기")
                        .font(.pretendardFont(.regular, size: 12))
                        .foregroundColor(.greyScale6)
                    Divider()
                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                        .frame(width: 50,height: 1.0)
                        .foregroundColor(.greyScale6)
                }
                .padding(.bottom, 36)
            }
        }
    }
}
struct PageDotsView: View {
    var numberOfPages: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack {
            HStack {
                ForEach(0..<numberOfPages, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.primary5 : Color.greyScale8)
                        .frame(width: 8, height: 8)
                   
                }
            }
            Spacer()
        }
    }
}
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
