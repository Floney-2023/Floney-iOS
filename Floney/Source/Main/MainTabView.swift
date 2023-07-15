//
//  MainTabView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct MainTabView: View {
    @State var selection = 0
    @State var showingAddView = false

    let icons = ["icon_home_off", "icon_leaderboard_off", "icon_add_circle", "icon_calculate_off", "icon_person_off"]
    let selectedIcons = ["icon_home_on", "icon_leaderboard_on", "", "icon_calculate_on", "icon_person_on"]
    let labels = ["홈", "분석", "", "정산", "마이"]
    init() {
        //UITabBar.appearance().backgroundColor = UIColor.white
        
    }
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }
    
    var body: some View {
        @State var currentDate = dateFormatter.string(from: Date())
        VStack {
            ZStack {
                Spacer().fullScreenCover(isPresented: $showingAddView) {
                    NavigationView {
                        AddView(isPresented: $showingAddView, date: currentDate)
                    }
                }
                switch selection {
                case 0:
                    NavigationView {
                        HomeView()
                    }
                case 1:
                    NavigationView {
                        AnalysisView()
                    }
                case 2:
                    NavigationView {
                        AddView(isPresented: $showingAddView, date: currentDate)
                    }
                case 3:
                    NavigationView {
                        CalculateView()
                    }
                default :
                    NavigationView {
                        MyPageView()
                    }
                }
            }
            Spacer()
            Divider()
            HStack {
                ForEach(0..<5, id: \.self) { number in
                    Spacer()
                    Button {
                        if number == 2 {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            currentDate = dateFormatter.string(from: Date())
                            self.showingAddView = true
                        } else {
                            self.selection = number
                        }
                    } label: {
                        VStack {
                            if number == 2 {
                                // add button
                                Image(icons[number])
                            } else {
                                Image(selection == number ? selectedIcons[number] : icons[number])
                            }
                            if number != 2 {  // Add button에는 텍스트가 필요 없습니다.
                                Text(labels[number])
                                    .font(.pretendardFont(.regular, size: 10))
                            }
                        }
                        .foregroundColor(selection == number ? .greyScale2 : .greyScale7)
                    }
                    Spacer()
                    
                }
            }
            
        }
    }
}
 
    /*
extension UITabBarController {
    override open func viewDidLoad() {
        let standardAppearance = UITabBarAppearance()
        
        standardAppearance.stackedItemPositioning = .centered
        standardAppearance.stackedItemSpacing = 44
        standardAppearance.stackedItemWidth = 60
        
      
        tabBar.standardAppearance = standardAppearance
    }
}*/

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
