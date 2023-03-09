//
//  MainTabView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct MainTabView: View {
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView().tabItem {
                if selection == 0 {
                    Image("icon_home_on")
                    Text("홈")
                        .font(.pretendardFont(.regular, size: 10))
                        .foregroundColor(.greyScale2)
                } else {
                    Image("icon_home_off")
                    Text("홈")
                        .foregroundColor(.greyScale7)
                }
                
            }.tag(0)
            
            AnalysisView().tabItem {
                if selection == 1 {
                    Image("icon_leaderboard_on")
                    Text("분석")
                        .foregroundColor(.greyScale2)
                } else {
                    Image("icon_leaderboard_off")
                    Text("분석")
                        .foregroundColor(.greyScale7)
                }
                
            }.tag(1)
            
            AddView().tabItem {
                Image("icon_add_circle")
            }.tag(2)
            
            CalculateView().tabItem {
                if selection == 3 {
                    Image("icon_calculate_on")
                    Text("정산")
                        .foregroundColor(.greyScale2)
                } else {
                    Image("icon_calculate_off")
                    Text("정산")
                        .foregroundColor(.greyScale7)
                }
                
            }.tag(3)
            
            MyPageView().tabItem {
                if selection == 4 {
                    Image("icon_person_on")
                    Text("마이")
                        .foregroundColor(.greyScale2)
                } else {
                    Image("icon_person_off")
                    Text("마이")
                        .foregroundColor(.greyScale7)
                }
            }.tag(4)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
