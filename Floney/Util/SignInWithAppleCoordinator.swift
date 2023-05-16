//
//  SignInWithAppleCoordinator.swift
//  Floney
//
//  Created by 남경민 on 2023/05/16.
//

import AuthenticationServices

class SignInWithAppleCoordinator: NSObject, ASAuthorizationControllerDelegate {

    private let onSuccess: (String) -> Void
    private let onError: (Error) -> Void

    init(onSuccess: @escaping (String) -> Void, onError: @escaping (Error) -> Void) {
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
            onSuccess(userId)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onError(error)
    }
}
