//
//  SignInWithAppleCoordinator.swift
//  Floney
//
//  Created by 남경민 on 2023/05/16.
//

import AuthenticationServices

class SignInWithAppleCoordinator: NSObject, ASAuthorizationControllerDelegate {
    
    private let onSuccess: (String, String, String, String) -> Void
    private let onError: (Error) -> Void

    init(onSuccess: @escaping (String, String, String, String) -> Void, onError: @escaping (Error) -> Void) {
        self.onSuccess = onSuccess
        self.onError = onError
    }

    func signIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.givenName ?? ""
            let email = appleIDCredential.email ?? ""
            var identityToken = ""
            if let identityTokenData = appleIDCredential.identityToken {
                identityToken = String(data: identityTokenData, encoding: .utf8) ?? ""
            }
            print(userId, fullName, email, identityToken)
            onSuccess(userId, fullName, email, identityToken)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onError(error)
    }
}
