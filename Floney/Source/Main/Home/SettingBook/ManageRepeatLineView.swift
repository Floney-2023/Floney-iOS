//
//  ManageRepeatLineView.swift
//  Floney
//
//  Created by 남경민 on 3/6/24.
//
import SwiftUI
import Combine
struct ManageRepeatLineView: View {
    let scaler = Scaler.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedOptions = 0
    @State private var selectedRepeatLineId = 0
    var options = ["지출", "수입", "이체"]
    @Binding var isShowing : Bool
    @State var editState = false
    @State var showEditButton = true
    @StateObject var viewModel = ManageRepeatLineViewModel()
    @State var deleteAlert = false
    @State var title = "반복 내역 삭제"
    @State var message = "반복 내역을 삭제하시겠습니까?\n해당 반복의 모든 내역이 삭제됩니다."
    @State private var secondsElapsed = 1
    @State private var timer: Timer?
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                VStack(spacing:0) {
                    VStack(alignment:.leading, spacing: 0){
                        HStack{
                            VStack(alignment:.leading, spacing: scaler.scaleHeight(16)) {
                                Text("반복 내역")
                                    .font(.pretendardFont(.bold,size:scaler.scaleWidth(24)))
                                    .foregroundColor(.greyScale1)
                                Text("반복 기능을 통해\n편하게 기록해 보세요")
                                    .lineSpacing(4)
                                    .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width:scaler.scaleWidth(76), height:scaler.scaleHeight(76))
                                .background(
                                    Image("illust_repeat")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:scaler.scaleWidth(76), height:scaler.scaleHeight(76))
                                    
                                )
                            
                        }
                    }
                    .padding(.horizontal,scaler.scaleWidth(24))
                    .padding(.bottom, scaler.scaleHeight(32))
                    
                    HStack(spacing: 0) {
                        ForEach(options.indices, id:\.self) { index in
                            ZStack {
                                Rectangle()
                                    .fill(Color.greyScale12)
                                Rectangle()
                                    .fill(Color.white)
                                    .cornerRadius(6)
                                    .padding(scaler.scaleWidth(4))
                                    .opacity(selectedOptions == index ? 1 : 0.01)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring()) {
                                            selectedOptions = index
                                        }
                                    }
                            }
                            .overlay(
                                Text(options[index])
                                    .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(14)))
                                    .foregroundColor(selectedOptions == index ? .greyScale2: .greyScale8)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height:scaler.scaleHeight(38))
                    .cornerRadius(8)
                    .padding(.horizontal,scaler.scaleWidth(20))
                    
                    if viewModel.repeatLineList.count == 0 {
                        VStack(spacing:scaler.scaleHeight(10)) {
                            Image("no_line")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: scaler.scaleWidth(38), height: scaler.scaleWidth(64))
                            Text("내역이 없습니다.")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                .foregroundColor(.greyScale6)
                        }
                        .padding(.top, scaler.scaleHeight(156))
                        .onAppear {
                            self.showEditButton = false
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(viewModel.repeatLineList, id: \.self) { (repeatLine:RepeatLineResponse) in
                                    VStack(alignment: .leading, spacing:0) {
                                        HStack(spacing:scaler.scaleWidth(12)) {
                                            if editState {
                                                Image("icon_delete")
                                                    .onTapGesture {
                                                        selectedRepeatLineId = repeatLine.id
                                                        self.deleteAlert = true
                                                    }
                                            }
                                            VStack(alignment: .leading, spacing:8) {
                                                Text("\(repeatLine.description)")
                                                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                                    .foregroundColor(.greyScale2)
                                                HStack(spacing:0) {
                                                    Text(repeatLine.repeatDurationDescription ?? "")
                                                    Text(" ‧ ")
                                                    Text("\(repeatLine.assetSubCategory)")
                                                    Text(" ‧ ")
                                                    Text("\(repeatLine.lineSubCategory)")
                                                }
                                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                                .foregroundColor(.greyScale6)
                                            }
                                            .padding(.leading, scaler.scaleWidth(12))
                                            Spacer()
                                            Text(repeatLine.money.formattedString)
                                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                                                .foregroundColor(.greyScale2)
                                                .padding(.trailing, scaler.scaleWidth(12))
                                        }
                                        .frame(height: scaler.scaleHeight(66))
                                        Divider()
                                            .foregroundColor(.greyScale11)
                                    }
                                }
                            }
                            .padding(.top, scaler.scaleHeight(16))
                            .padding(.horizontal,scaler.scaleWidth(22))
                            .padding(.bottom,  scaler.scaleHeight(64))
                        }
                        .onAppear {
                            self.showEditButton = true
                        }
                    }
                } // VStack
                .padding(.top, scaler.scaleHeight(32))
            } // VStack
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{
                viewModel.categoryType = "OUTCOME"
                viewModel.fetchAllCategoriesAndCheck()
                viewModel.getRepeatLine()            }
            .onDisappear {
                stopTimer()
            }
            .onChange(of: selectedOptions) { newValue in
                if options[newValue] == "지출" {
                    viewModel.categoryType = "OUTCOME"
                } else if options[newValue] == "수입"{
                    viewModel.categoryType = "INCOME"
                } else if options[newValue] == "이체"{
                    viewModel.categoryType = "TRANSFER"
                }
                viewModel.getRepeatLine()
            }
            .customNavigationBar(
                leftView: {
                    Image("icon_back")
                        .onTapGesture {
                            isShowing = false
                            self.presentationMode.wrappedValue.dismiss()
                                                }
                },
                rightView: {
                    Group {
                        if viewModel.showEditButton {
                            Group {
                                if editState {
                                    Button {
                                        self.editState = false
                                    } label: {
                                        Text("완료")
                                            .font(.pretendardFont(.regular,size:scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale2)
                                    }
                                    
                                } else {
                                    Button {
                                        self.editState = true
                                    } label: {
                                        Text("편집")
                                            .font(.pretendardFont(.regular,size:scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale2)
                                    }
                                }
                            }
                        } else {
                            EmptyView()
                        }
                    }
                }
            )
            if deleteAlert {
                FloneyAlertView(isPresented: $deleteAlert, title:$title, message: $message, leftButtonText:"삭제하기") {
                    viewModel.deleteRepeatLine(repeatLineId: self.selectedRepeatLineId)
                    startTimer()
                }
            }
            if viewModel.isApiCalling {
                LoadingView()
            }
        }
    }
    func startTimer() {
        secondsElapsed = 1
        timer?.invalidate() // 기존 타이머가 있다면 중지
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                self.secondsElapsed += 1
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct ManageRepeatLineView_Previews: PreviewProvider {
    static var previews: some View {
        ManageRepeatLineView(isShowing: .constant(true))
    }
}
