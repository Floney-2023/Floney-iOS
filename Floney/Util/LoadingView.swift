//
//  LoadingView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/12.
//

import SwiftUI

struct LoadingView: View {
    @State private var offset1: CGFloat = 0
    @State private var offset2: CGFloat = 0
    @State private var offset3: CGFloat = 0

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(y: offset1)
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(y: offset2)
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(y: offset3)
            }
            .foregroundColor(.primary5)
            .padding(20)
            //.background(Color.black.opacity(0.7))
            .cornerRadius(20)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.7))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                offset1 = -20
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    offset2 = -20
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    offset3 = -20
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
