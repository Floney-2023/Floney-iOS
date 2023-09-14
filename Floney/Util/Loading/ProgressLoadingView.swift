//
//  ProgressLoadingView.swift
//  Floney
//
//  Created by 남경민 on 2023/08/14.
//

import SwiftUI

struct ProgressLoadingView: View {
    var body: some View {
        VStack {
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.greyScale4))
                .scaleEffect(2.0)
            //Text("Loading...")
               // .foregroundColor(.gray)
        }
       // .padding()
      //  .background(Color.white)
      //  .cornerRadius(10)
      //  .shadow(radius: 10)
      //
        
    }
}
struct DimmedLoadingView: View {
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            // Loading indicator and text
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .scaleEffect(2.0)
            }
            
        }
    }
}

struct ProgressLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressLoadingView()
        //DimmedLoadingView()
    }
}
