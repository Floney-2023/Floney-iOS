//
//  BackButton.swift
//  Floney
//
//  Created by 남경민 on 2023/03/08.
//

import SwiftUI

struct BackButton : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("back_button") // set image here
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct BackButtonBlack : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("back_button_black") // set image here
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct BackButtonBlackWithAlert : View {
    @Binding var showAlert : Bool
    @Binding var changedStatus : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        Button(action: {
            if changedStatus {
                showAlert = true
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            HStack {
                Image("back_button_black") // set image here
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
