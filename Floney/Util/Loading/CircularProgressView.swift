//
//  CircularProgressView.swift
//  Floney
//
//  Created by 남경민 on 3/13/24.
//

import Foundation
import SwiftUI

struct CircularProgressView: View {
    @State private var progress = 0.0

    // 타이머를 설정합니다. 10초 동안 100까지 카운트하기 위해 0.1초마다 발생합니다.
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            ZStack {
                // 프로그레스 바의 배경 원
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.3)
                    .foregroundColor(Color.greyScale8)

                // 프로그레스 바의 진행 원
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress / 100.0, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.primary1)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: progress)
            }
            .frame(width: 150.0, height: 150.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.7))
        .edgesIgnoringSafeArea(.all)
        .onReceive(timer) { _ in
            self.progress += 1
            if self.progress >= 100 {
                self.timer.upstream.connect().cancel() // 100에 도달하면 타이머 종료
            }
        }
        .onDisappear {
            self.timer.upstream.connect().cancel()
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView()
    }
}
