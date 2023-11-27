//
//  AnnouncementView.swift
//  Floney
//
//  Created by 남경민 on 2023/11/03.
//

import SwiftUI

struct Announcement:Hashable {
    let title : String
    let date : String
    let content : String
    var showingDetail : Bool
}

struct AnnouncementView: View {
    let scaler = Scaler.shared
    @Binding var showingTabbar : Bool
    @State var list : [Announcement] = [
        Announcement(title: "플로니가 출시되었어요🍀", date: "2023-10-02", content: "안녕하세요!\n공유가계부 플로니가 출시되었습니다.\n사용 중 궁금하거나 불편한 점이 있으시면 문의하기를 통해 메일로 물어봐 주시면 언제든지 친절하게 답변해 드립니다.\n\n많은 이용과 관심 부탁드립니다.\n감사합니다.", showingDetail: false),
        Announcement(title: "플로니가 출시되었어요🍀", date: "2023-10-02", content: "안녕하세요!\n공유가계부 플로니가 출시되었습니다.\n사용 중 궁금하거나 불편한 점이 있으시면 문의하기를 통해 메일로 물어봐 주시면 언제든지 친절하게 답변해 드립니다.\n\n많은 이용과 관심 부탁드립니다.\n감사합니다.", showingDetail: false)
    ]
    var body: some View {
        VStack(spacing:0) {
            ScrollView {
                ForEach(list.indices, id: \.self) { index in
                    CustomDisclosureGroup(animation: .easeInOut(duration: 0.2), isExpanded: $list[index].showingDetail) {
                        list[index].showingDetail.toggle()
                        
                    } prompt: {
                        HStack {
                            VStack(alignment:.leading, spacing:scaler.scaleHeight(8)) {
                                Text("\(list[index].title)")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale2)
                                Text("\(list[index].date)")
                                    .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                    .foregroundColor(.greyScale6)
                            }
                            .padding(.leading, scaler.scaleWidth(28))
                            Spacer()
                            Image(list[index].showingDetail ? "icon_chevron_fold" : "icon_chevron_unfold")
                                .padding(.trailing, scaler.scaleWidth(24))
                        }
                        .frame(height: scaler.scaleHeight(66))
                    } expandedView: {
                        VStack {
                            Text("\(list[index].content)")
                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(13)))
                                .foregroundColor(.greyScale3)
                                .padding(.horizontal, scaler.scaleWidth(28))
                                .padding(.vertical, scaler.scaleHeight(16))
                        }
                        .background(Color.greyScale12)

                    }
                    
                }
            }
        }
        .customNavigationBar(
            leftView: { BackButtonBlack() },
            centerView: {
                Text("공지사항")
                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                .foregroundColor(.greyScale1) }
        )
        .onAppear {
            showingTabbar = false
        }
    }
}

struct CustomDisclosureGroup<Prompt: View, ExpandedView: View>: View {
    @Binding var isExpanded: Bool

    var actionOnClick: () -> ()
    var animation: Animation?
    
    let prompt: Prompt
    let expandedView: ExpandedView
    
    init(animation: Animation?, isExpanded: Binding<Bool>, actionOnClick: @escaping () -> (), prompt: () -> Prompt, expandedView: () -> ExpandedView) {
        self.actionOnClick = actionOnClick
        self._isExpanded = isExpanded
        self.animation = animation
        self.prompt = prompt()
        self.expandedView = expandedView()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            prompt
            
            if isExpanded{
                expandedView
            }
        }
        .clipped()
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(animation) {
                actionOnClick()
            }
        }
    }
}


struct AnnouncementView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementView(showingTabbar: .constant(false))
    }
}
