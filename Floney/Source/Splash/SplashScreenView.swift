//
//  SplashScreenView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/02.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            
            //
            //SignInView()
             
            //AddView()
            MainTabView()
        } else {
            ZStack {
                Image("splash_bg")
                    .resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    .ignoresSafeArea()
                Image("splash_logo")
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                    
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
