//
//  MainTabView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct MainTabView: View {
    var bookService = BookExistenceViewModel.shared
    @State var showingInactiveAlert = false
    let scaler = Scaler.shared
    @State var selection = 0
    @State var settlementId = 0
    @State var showingSettlementList = false
    @State var showingSettlementDetail = false
    @State var showingAddView = false
    @State var showingTabbar = true
    @State var isNextToCreateBook = false
    @State var isNextToEnterCode = false
    
    @State var isShowingAccountBottomSheet = false
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
                //ZStack {
                Spacer().fullScreenCover(isPresented: $showingAddView) {
                    NavigationView {
                        AddView(isPresented: $showingAddView,date:currentDate)
                            .transition(.moveAndFade)
                    }
                    .navigationViewStyle(.stack)
                }
                switch selection {
                case 0:
                    NavigationView {
                        HomeView(showingTabbar: $showingTabbar, mainAddViewStatus: $showingAddView)
                    }
                    .navigationViewStyle(.stack)
                case 1:
                    NavigationView {
                        
                        AnalysisView(showingTabbar: $showingTabbar)
                    }.navigationViewStyle(.stack)
                case 2:
                    NavigationView {
                        AddView(isPresented: $showingAddView, date:currentDate)
                            .transition(.moveAndFade)
                    }.navigationViewStyle(.stack)
                case 3:
                    NavigationView {
                        CalculateView(settlementId: $settlementId, isShowingSettlement: $showingSettlementList, showingTabbar: $showingTabbar, showingDetail: $showingSettlementDetail)
                    }.navigationViewStyle(.stack)
                        .onAppear{
                                print("Main Tab View : 정산 리스트 보여주나요 ? :\(showingSettlementList)")
                                print("Main Tab View : 정산 디테일도 보여주나요 ? :\(showingSettlementDetail)")
                            
                        }
                default :
                    NavigationView {
                        MyPageView(showingTabbar: $showingTabbar, isShowingAccountBottomSheet: $isShowingAccountBottomSheet, isNextToCreateBook: $isNextToCreateBook, isNextToEnterCode: $isNextToEnterCode)
                    }.navigationViewStyle(.stack)
                }
                //}
            }
            //MARK: Tab Bar
            if showingTabbar {
                VStack {
                    Spacer()
                    VStack(spacing:0) {
                        
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: scaler.scaleHeight(1))
                            .foregroundColor(.greyScale10)
                            .background(Color.greyScale10)
                        
                        HStack(spacing:0) {
                            Button {
                                self.selection = 0
                                CurrencyManager.shared.getCurrency()
                                /*
                                if bookService.bookDisabled {
                                    showingInactiveAlert = true
                                }*/
                            } label: {
                                VStack(spacing: scaler.scaleHeight(4)) {
                                    Image(selection == 0 ? selectedIcons[0] : icons[0])
                                        .resizable()
                                        .frame(width:scaler.scaleWidth(24), height: scaler.scaleWidth(24))
                                    
                                    Text(labels[0])
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(10)))
                                }
                                .foregroundColor(selection == 0 ? .greyScale2 : .greyScale7)
                                
                            }
                            .padding(.top, scaler.scaleHeight(5))
                            .padding(.bottom, scaler.scaleHeight(12))
                            .padding(.leading, scaler.scaleWidth(36))
                            .buttonStyle(.plain)
                            Button {
                                self.selection = 1
                                CurrencyManager.shared.getCurrency()
                                /*
                                if bookService.bookDisabled {
                                    showingInactiveAlert = true
                                }*/
                            } label: {
                                VStack(spacing: scaler.scaleHeight(4)) {
                                    Image(selection == 1 ? selectedIcons[1] : icons[1])
                                        .resizable()
                                        .frame(width:scaler.scaleWidth(24), height: scaler.scaleWidth(24))
                                    
                                    Text(labels[1])
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(10)))
                                }
                                .foregroundColor(selection == 1 ? .greyScale2 : .greyScale7)
                                
                            }
                            .padding(.top, scaler.scaleHeight(5))
                            .padding(.bottom, scaler.scaleHeight(12))
                            .padding(.leading, scaler.scaleWidth(44))
                            .buttonStyle(.plain)
                            
                            Button {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                currentDate = dateFormatter.string(from: Date())
                                CurrencyManager.shared.getCurrency()
                                self.showingAddView = true
                                /*
                                if bookService.bookDisabled {
                                    showingInactiveAlert = true
                                } else {
                                    self.showingAddView = true
                                }*/
                            } label: {
                                VStack {
                                    Image(icons[2])
                                        .resizable()
                                        .frame(width:scaler.scaleWidth(56), height: scaler.scaleWidth(56))
                                }
                                
                            }
                            .padding(.leading, scaler.scaleWidth(24))
                            
                            
                            Button {
                                self.selection = 3
                                CurrencyManager.shared.getCurrency()
                                /*
                                if bookService.bookDisabled {
                                    showingInactiveAlert = true
                                }*/
                            } label: {
                                VStack(spacing: scaler.scaleHeight(4)) {
                                    Image(selection == 3 ? selectedIcons[3] : icons[3])
                                        .resizable()
                                        .frame(width:scaler.scaleWidth(24), height: scaler.scaleWidth(24))
                                    
                                    Text(labels[3])
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(10)))
                                }
                                .foregroundColor(selection == 3 ? .greyScale2 : .greyScale7)
                                
                            }
                            .padding(.top, scaler.scaleHeight(5))
                            .padding(.bottom, scaler.scaleHeight(12))
                            .padding(.leading, scaler.scaleWidth(24))
                            .buttonStyle(.plain)
                            
                            Button {
                                self.selection = 4
                                CurrencyManager.shared.getCurrency()
                            } label: {
                                VStack(spacing: scaler.scaleHeight(4)) {
                                    Image(selection == 4 ? selectedIcons[4] : icons[4])
                                        .resizable()
                                        .frame(width:scaler.scaleWidth(24), height: scaler.scaleWidth(24))
                                    
                                    Text(labels[4])
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(10)))
                                }
                                .foregroundColor(selection == 4 ? .greyScale2 : .greyScale7)
                                
                            }
                            .padding(.top, scaler.scaleHeight(5))
                            .padding(.bottom, scaler.scaleHeight(12))
                            .padding(.leading, scaler.scaleWidth(44))
                            .padding(.trailing, scaler.scaleWidth(36))
                            .buttonStyle(.plain)
                        }
                        .padding(.top, scaler.scaleHeight(2))
                        .padding(.bottom, scaler.scaleHeight(18))
                    }
                    .background(Color.white)
                    .frame(height:scaler.scaleHeight(76))
                }
            } // showing tab
            
            

            AccountBookBottomSheet(isShowing: $isShowingAccountBottomSheet, showingTabbar: $showingTabbar, isNextToCreateBook: $isNextToCreateBook, isNextToEnterCode: $isNextToEnterCode)
            CustomAlertView(message: AlertManager.shared.message, type : $alertManager.buttontType, isPresented: $alertManager.showAlert)
            
            InactiveAlertView(isPresented: $showingInactiveAlert)
            
            
        }
        .ignoresSafeArea()

    }
    
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
