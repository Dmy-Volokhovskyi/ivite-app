//
//  ResendButtonView.swift
//  ivite-app
//
//  Created by Дмитро Волоховський on 07/12/2024.
//
import UIKit

protocol ResendButtonViewDelegate: AnyObject {
    func didTapResendButton()
}

final class ResendButtonView: BaseView {

    private let resendButton = UIButton(configuration: .primary(title: "Resend link"))
    private var countdownTimer: Timer?
    private var remainingSeconds = 59
    
    weak var delegate: ResendButtonViewDelegate?

    override func setupView() {
        super.setupView()

        resendButton.addTarget(self, action: #selector(didTapResendButton), for: .touchUpInside)
        addSubview(resendButton)
    }

    override func constrainSubviews() {
        super.constrainSubviews()
        resendButton.autoPinEdgesToSuperviewEdges()
    }

    @objc private func didTapResendButton() {
        delegate?.didTapResendButton()
        startCountdown()
    }

    public func startCountdown() {
        // Disable the button and apply disabled configuration
        resendButton.configuration = .disabledPrimary(title: "Resend link")
        resendButton.isUserInteractionEnabled = false

        // Start the timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc private func updateCountdown() {
        if remainingSeconds > 0 {
            let title = "Resend link \(String(format: "%02d", remainingSeconds))"
            updateButtonTitle(with: title)
            remainingSeconds -= 1
        } else {
            countdownTimer?.invalidate()
            remainingSeconds = 59

            // Re-enable the button and apply normal configuration
            resendButton.isUserInteractionEnabled = true
            resendButton.configuration = .primary(title: "Resend link")
        }
    }

    private func updateButtonTitle(with title: String) {
        var configuration = resendButton.configuration
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .interFont(ofSize: 14, weight: .semiBold)
        attributedTitle.foregroundColor = UIColor.primaryLight10
        configuration?.attributedTitle = attributedTitle
        resendButton.configuration = configuration
    }
}
