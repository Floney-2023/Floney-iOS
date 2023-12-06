//
//  ButtonClickHandler.swift
//  Floney
//
//  Created by 남경민 on 12/6/23.
//

import Foundation
import Combine

// 버튼 클릭 이벤트 처리를 위한 클래스
class ButtonClickHandler {
    private var action: (() -> Void)?
    private var cancellables = Set<AnyCancellable>()
    @Published private var buttonClicked = false

    init() {
        setupThrottle()
    }

    func setupAction(action: @escaping () -> Void) {
        self.action = action
    }

    func click() {
        buttonClicked = true
    }

    private func setupThrottle() {
        $buttonClicked
            .throttle(for: 3.0, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] clicked in
                if clicked {
                    self?.action?()
                    self?.buttonClicked = false
                }
            }
            .store(in: &cancellables)
    }
}
