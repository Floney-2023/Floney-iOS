//
//  AlertManager.swift
//  Floney
//
//  Created by 남경민 on 2023/08/14.
//

import Foundation

class AlertManager: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    static let shared = AlertManager()  // Singleton instance
    @Published var showAlert = false
    @Published var message = ""
    @Published var buttontType : ButtonType = .red
    
    func update(showAlert: Bool, message: String, buttonType : ButtonType) {
        self.showAlert = showAlert
        self.message = message
        self.buttontType = buttonType
    }
    func handleError(_ error: CustomError) {
        self.update(showAlert: true, message: error.errorMessage, buttonType: .red)
    }
}
