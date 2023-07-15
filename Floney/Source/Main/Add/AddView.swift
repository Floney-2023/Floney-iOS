//
//  AddView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI
import Combine
struct AddView: View {
    @Binding var isPresented: Bool
    
    @StateObject var viewModel = AddViewModel()
    @State var date : String = "2023-06-20"
    @State var money : String = ""
    @State private var selectedView: Int = 1
    @State var assetType = "자산을 선택하세요."
    @State var category = "분류를 선택하세요."
    @State var maxLength = 12
    @State var content = ""
    @State var toggleOnOff = false
    
    @State var isShowingBottomSheet = false
    @State var isSelectedAssetTypeIndex = 0
    @State var isSelectedCategoryIndex = 0
    @State var root = ""
    @State var toggleType = "지출"
    
    @State var selectedAssetType = ""
    @State var selectedCategory = ""
    
    
    @State var categories: [String] = ["현금", "체크카드", "신용카드", "은행","추가", "추가추가","추가/추가"]
    @State var isShowingEditCategory = false
    
    @State var options = ["지출", "수입", "이체"]
    @State var selectedOptions = 0
        
    var body: some View {
        @State var moneyStr = String(describing: "\(money)")
        ZStack {
            VStack {
                HStack {
                    Image("icon_close")
                        .onTapGesture {
                            self.isPresented.toggle()
                        }
                    Spacer()
                }
                .padding(20)

                VStack(spacing: 32){
                    //MARK: 금액
                    VStack {
                        HStack {
                            Text("금액")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale6)
                            Spacer()
                        }
                        TextField("", text: $money)
                            .keyboardType(.numberPad)
                            .foregroundColor(.primary2)
                            .font(.pretendardFont(.bold, size: 38))
                        
                            .overlay(
                                Text("금액을 입력하세요.")
                                    .font(.pretendardFont(.bold, size: 36))
                                    .foregroundColor(.greyScale9)
                                    .opacity(money.isEmpty ? 1 : 0)
                                
                                , alignment: .leading
                            )
                            .overlay(
                                Text("\(moneyStr)원")
                                    .font(.pretendardFont(.bold, size: 38))
                                    .foregroundColor(.primary2)
                                    .opacity(money.isEmpty ? 0 : 1)
                                
                                , alignment: .leading
                            )
                            .onReceive(Just(money)) { value in
                                let digits = value.filter { "0"..."9" ~= $0 }
                                if let intValue = Int(digits), intValue <= 100_000_000_000 {
                                    moneyStr = formatNumber(intValue)
                                } else {
                                    moneyStr = String(digits.dropLast())
                                }
                            }
                        
                    } // 금액 VStack
                    
                    //MARK: 지출/수입/이체 선택 토글 버튼
                    HStack(spacing: 0) {
                        ForEach(options.indices, id:\.self) { index in
                            ZStack {
                                Rectangle()
                                    .fill(Color.greyScale10)
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .cornerRadius(8)
                                    .padding(4)
                                    .opacity(selectedOptions == index ? 1 : 0.01)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring()) {
                                            selectedOptions = index
                                            toggleType = options[selectedOptions]
                                        }
                                    }
                            }
                            .overlay(
                                Text(options[index])
                                
                                    .font(.pretendardFont(.semiBold, size: 11))
                                    .foregroundColor(selectedOptions == index ? .greyScale2: .greyScale8)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .cornerRadius(10)
                    
                    //MARK: 날짜/자산/분류/내용/제외여부
                    VStack(spacing:44) {
                        HStack {
                            Text("날짜")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale4)
                            Spacer()
                            Text("\(date)")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                        }
                        HStack {
                            Text("자산")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale4)
                            Spacer()
                            //MARK: 눌렀을 때 bottom sheet
                            Text("\(assetType)")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale6)
                        }
                        .onTapGesture {
                            self.root = "자산"
                            viewModel.root = self.root
                            viewModel.getCategory()
                            //self.categories = viewModel.categories
                            print("\(self.categories)")
                            self.isShowingBottomSheet.toggle()
                        }
                        HStack {
                            Text("분류")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale4)
                            Spacer()
                            
                            Text("\(category)")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale6)
                        }
                        .onTapGesture {
                            self.root = self.toggleType
                            viewModel.root = self.root
                            viewModel.getCategory()
                            
                            self.isShowingBottomSheet.toggle()
                        }
                        HStack {
                            Text("내용")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale4)
                            
                            TextField("", text: $content)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: content) { newValue in
                                    if newValue.count > maxLength {
                                        content = String(newValue.prefix(maxLength))
                                    }
                                }
                                .overlay(
                                    Text("내용을 입력하세요.")
                                        .font(.pretendardFont(.medium, size: 14))
                                        .foregroundColor(.greyScale6)
                                        .opacity(content.isEmpty ? 1 : 0)
                                    
                                    , alignment: .trailing
                                )
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            //.background(Color.red)
                        }
                        HStack {
                            Text("예산에서 제외")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale4)
                            Spacer()
                            Toggle(isOn: $toggleOnOff) {
                                
                            }.padding(.trailing, 6)
                        }
                    }.padding(.leading, 10)
                    .padding(.trailing, 6)
                    
                } //VStack
                .padding(20)
                
                Spacer()
                //MARK: 삭제/저장하기 버튼
                HStack(spacing:0) {
                    Button {
                        //
                    } label: {
                        Text("삭제")
                        
                            .font(.pretendardFont(.bold, size:14))
                            .foregroundColor(.white)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.greyScale2)
                    Button {
                        //
                        
                        viewModel.money = money
                        viewModel.lineDate = date
                        viewModel.flow = toggleType
                        viewModel.asset = assetType
                        viewModel.line = category
                        viewModel.description = content
                        viewModel.except = toggleOnOff
                        
                        print(viewModel.money)
                        print(viewModel.lineDate)
                        print(viewModel.flow)
                        print(viewModel.asset)
                        print(viewModel.line)
                        print(viewModel.description)
                        print(viewModel.except)
                        
                        viewModel.postLines()
                        
                    } label: {
                        Text("저장하기")
                            .font(.pretendardFont(.bold, size:14))
                        
                            .foregroundColor(.white)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(width: UIScreen.main.bounds.width * 2/3)
                    .padding()
                    .background(Color.primary1)
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
                .frame(height: 66)
                
                
            } // VStack
            .onAppear(perform : UIApplication.shared.hideKeyboard)

            CategoryBottomSheet(root: $root, categories: $viewModel.categories, isShowing: $isShowingBottomSheet, isSelectedAssetTypeIndex: $isSelectedAssetTypeIndex, isSelectedAssetType: $assetType, isSelectedCategoryIndex: $isSelectedCategoryIndex, isSelectedCategory: $category, isShowingEditCategory: $isShowingEditCategory)
            
            NavigationLink(destination: CategoryManagementView(isShowingEditCategory: $isShowingEditCategory), isActive: $isShowingEditCategory) {
                EmptyView()
            }
            
            
        } // ZStack
    }
    func formatNumber(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: n)) ?? ""
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(isPresented: .constant(true))
    }
}
