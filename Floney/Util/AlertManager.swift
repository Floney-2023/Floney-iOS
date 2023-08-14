//
//  AlertManager.swift
//  Floney
//
//  Created by 남경민 on 2023/08/14.
//

import Foundation

class AlertManager: ObservableObject {
    static let shared = AlertManager()  // Singleton instance
    @Published var showAlert = false
    @Published var message = ""
    @Published var buttontType = ""
    
    func update(showAlert: Bool, message: String, buttonType : String) {
        self.showAlert = showAlert
        self.message = message
        self.buttontType = buttonType
    }
}
