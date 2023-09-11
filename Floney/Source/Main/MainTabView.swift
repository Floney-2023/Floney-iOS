//
//  MainTabView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct MainTabView: View {
    @State var selection = 0
    @State var settlementId = 0
    @State var showingSettlementList = false
    @State var showingSettlementDetail = false
    @State var showingAddView = false
    @State var showingTabbar = true
    @ObservedObject var alertManager = AlertManager.shared
    @ObservedObject var loadingManager = LoadingManager.shared
    
    var lineModel = LineModel()
    let icons = ["icon_home_off", "icon_leaderboard_off", "icon_add_circle", "icon_calculate_off", "icon_person_off"]
    let selectedIcons = ["icon_home_on", "icon_leaderboard_on", "", "icon_calculate_on", "icon_person_on"]
    let labels = ["홈", "분석", "", "정산", "마이"]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }
    
    var body: some View {
        @State var currentDate = dateFormatter.string(from: Date())
        ZStack {
            VStack {
                ZStack {
                    Spacer().fullScreenCover(isPresented: $showingAddView) {
               
                        NavigationView {
                            AddView(isPresented: $showingAddView,lineModel: lineModel,date:currentDate)
                                .transition(.moveAndFade)
                        }
                    }
                    switch selection {
                    case 0:
                        NavigationView {
                           
                            HomeView(showingTabbar: $showingTabbar)
                        }
                    case 1:
                        NavigationView {
                           
                            AnalysisView(showingTabbar: $showingTabbar)
                        }
                    case 2:
                        NavigationView {
                            
                            AddView(isPresented: $showingAddView,lineModel: lineModel, date:currentDate)
                                .transition(.moveAndFade)
                        }
                    case 3:
                        NavigationView {
                            CalculateView(settlementId: $settlementId, isShowingSettlement: $showingSettlementList, showingTabbar: $showingTabbar, showingDetail: $showingSettlementDetail)
                        }
                    default :
                        NavigationView {
                           
                           MyPageView(showingTabbar: $showingTabbar)
                        }
                    }
                }
   
                //MARK: Tab Bar
                if showingTabbar {
                    VStack(spacing:0) {
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .foregroundColor(.greyScale10)
                            .background(Color.greyScale10)
                        HStack() {
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
                                .padding(.bottom, 18)
                                Spacer()
                                
                            }
                            //.frame(maxHeight: .infinity)
                            .frame(height:UIScreen.main.bounds.height * 0.098)
                            
                        }
                        .padding(.bottom, 18)
                    }
                    .background(Color.white)
                    .frame(height:UIScreen.main.bounds.height * 0.098)
                }
                
            }
           
            .edgesIgnoringSafeArea(.bottom)
            // Loading view overlay
            if loadingManager.showLoading {
                if loadingManager.loadingType == .floneyLoading {
                    LoadingView()
                }
                else if loadingManager.loadingType == .progressLoading{
                    ProgressLoadingView()
                } else {
                    DimmedLoadingView()
                }
            }
            
            CustomAlertView(message: AlertManager.shared.message, type : $alertManager.buttontType, isPresented: $alertManager.showAlert)
            
        }
    }
}
 

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
