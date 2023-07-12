//
//  LoadingMotionView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/12.
//

import SwiftUI

struct LoadingMotionView: View {
    let loadingImages: [String] = ["loading4", "loading2", "loading3"]
    @State private var currentImageIndex = 0

    var body: some View {
        VStack {
            Spacer()
            Image(loadingImages[currentImageIndex])
                //.resizable()
                //.frame(width: 100, height: 100)
                //.scaledToFit()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.7))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                currentImageIndex = (currentImageIndex + 1) % loadingImages.count
            }
        }
    }
}


struct LoadingMotionView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingMotionView()
    }
}
