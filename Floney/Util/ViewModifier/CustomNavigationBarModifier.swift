//
//  CustomNavigationBarModifier.swift
//  Floney
//
//  Created by 남경민 on 2023/09/17.
//

import Foundation
import SwiftUI

struct CustomNavigationBarModifier<C, L, R> : ViewModifier where C : View, L : View, R : View {
    let scaler = Scaler.shared
    let centerView: (() -> C)?
    let leftView: (() -> L)?
    let rightView: (() -> R)?
    
    init(centerView: (() -> C)? = nil, leftView: (() -> L)? = nil, rightView: (() -> R)? = nil) {
        self.centerView = centerView
        self.leftView = leftView
        self.rightView = rightView
    }
    func body(content : Content) -> some View {
        VStack {
            ZStack {
                HStack {
                    self.leftView?()
                    Spacer()
                    self.rightView?()
                }
                .frame(height: scaler.scaleHeight(46.0))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, scaler.scaleWidth(20))
                        
                HStack {
                    Spacer()
                    
                    self.centerView?()
                    
                    Spacer()
                }
            }
            .background(Color.clear)//.ignoresSafeArea(.all, edges: .top)
            
           content

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}
