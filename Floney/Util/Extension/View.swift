//
//  View.swift
//  Floney
//
//  Created by 남경민 on 2023/04/08.
//

import SwiftUI

extension View {
    // MARK: call next button modifier
    func withNextButtonFormmating(_ backgroundColor: Color = .blue) -> some View {
        // RETURN BODY
        modifier(NextButtonModifier(backgroundColor: backgroundColor))
    }
    
    // MARK: corner radius
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorners(radius: radius, corners: corners) )
    }
    
    func customNavigationBar<L>(
        leftView: @escaping (()-> L)
    ) -> some View where L : View {
        modifier(
            CustomNavigationBarModifier(
                centerView: { EmptyView() },
                leftView: leftView,
                rightView: { EmptyView() }
            )
        )
    }
    func customNavigationBar<R>(
        rightView: @escaping (()-> R)
    ) -> some View where R : View {
        modifier(
            CustomNavigationBarModifier(
                centerView: { EmptyView() },
                leftView: { EmptyView()} ,
                rightView: rightView 
            )
        )
    }
    
    func customNavigationBar<L,R>(
        leftView: @escaping (()-> L),
        rightView: @escaping (()-> R)
    ) -> some View where L : View, R: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: { EmptyView() },
                leftView: leftView,
                rightView: rightView
            )
        )
    }
    func customNavigationBar<C,R>(
        centerView: @escaping (()-> C),
        rightView: @escaping (()-> R)
    ) -> some View where C : View, R: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: { EmptyView() },
                rightView: rightView
            )
        )
    }
    func customNavigationBar<C,L>(
        leftView: @escaping (()-> L),
        centerView: @escaping (()-> C)
    ) -> some View where C : View, L: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: leftView,
                rightView: { EmptyView() }
            )
        )
    }
}
