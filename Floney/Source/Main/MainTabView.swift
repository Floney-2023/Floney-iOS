//
//  MainTabView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct MainTabView: View {
    @State var selection = 0
    init() {
    UITabBar.appearance().backgroundColor = UIColor.white

    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                HomeView().tabItem {
                    if selection == 0 {
                        Image("icon_home_on")
                    } else {
                        Image("icon_home_off")
                    }
                    Text("홈")
                }.tag(0)
                
                
                
                AnalysisView().tabItem {
                    if selection == 1 {
                        Image("icon_leaderboard_on")
                    } else {
                        Image("icon_leaderboard_off")
                    }
                    Text("분석")
                }.tag(1)
                
                AddView().tabItem {
                    Image("icon_add_circle")
                }.tag(2)
                
                CalculateView().tabItem {
                    if selection == 3 {
                        Image("icon_calculate_on")
                    } else {
                        Image("icon_calculate_off")
                    }
                    Text("정산")
                    
                }.tag(3)
                
                MyPageView().tabItem {
                    if selection == 4 {
                        Image("icon_person_on")
                    } else {
                        Image("icon_person_off")
                    }
                    Text("마이")
                }.tag(4)
                
            }
            .accentColor(.greyScale2)
        }
    }
}
extension UITabBarController {
    override open func viewDidLoad() {
        let standardAppearance = UITabBarAppearance()
        
        standardAppearance.stackedItemPositioning = .centered
        standardAppearance.stackedItemSpacing = 44
        standardAppearance.stackedItemWidth = 60
        
      
        tabBar.standardAppearance = standardAppearance
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
