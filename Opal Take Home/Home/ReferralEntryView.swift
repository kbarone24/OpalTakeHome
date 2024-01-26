//
//  RewardsView.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit

protocol RewardsViewDelegate: AnyObject {
    func finishPassing(referralCount: Int, proUser: Bool)
}

class ReferralEntryView: UIView {
    private lazy var referralLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter number of referrals"
        label.font = TextStyle.largeButton.font
        label.textColor = .black
        return label
    }()

    private(set) lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.textAlignment = .left
        textField.textColor = UIColor(color: .textPrimary)
        textField.tintColor = UIColor(color: .opalBlue)
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.delegate = self
        textField.textColor = .black
        textField.text = "0"
        return textField
    }()

    private lazy var proLabel: UILabel = {
        let label = UILabel()
        label.text = "Is this a pro user?"
        label.font = TextStyle.largeButton.font
        label.textColor = .black
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private lazy var proSwitch: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        view.tintColor = UIColor.black.withAlphaComponent(0.3)
        view.onTintColor = UIColor(color: Color.opalBlue)
        return view
    }()

    private lazy var goButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(color: .opalBlue)
        button.layer.cornerRadius = 14
        button.setTitle("Go", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = TextStyle.largeButton.font
        button.addTarget(self, action: #selector(goTap), for: .touchUpInside)
        return button
    }()

    weak var delegate: RewardsViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white
        layer.cornerRadius = 14

        addSubview(referralLabel)
        referralLabel.snp.makeConstraints {
            $0.leading.top.equalTo(32)
        }

        addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalTo(referralLabel.snp.bottom).offset(16)
            $0.leading.equalTo(referralLabel)
            $0.width.equalTo(48)
        }

        addSubview(proLabel)
        proLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(32)
            $0.leading.equalTo(textField)
        }

        addSubview(proSwitch)
        proSwitch.snp.makeConstraints {
            $0.top.equalTo(proLabel.snp.bottom).offset(16)
            $0.leading.equalTo(proLabel)
        }

        addSubview(goButton)
        goButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func goTap() {
        let referralCount = Int(textField.text ?? "") ?? 0
        let proUser = proSwitch.isOn

        DispatchQueue.main.async {
            HapticGenerator.shared.play(.light)
            self.textField.resignFirstResponder()
            self.delegate?.finishPassing(referralCount: referralCount, proUser: proUser)
        }
    }
}

extension ReferralEntryView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        // 3 characters max, numbers only
        return updatedText.count <= 3 && updatedText.allSatisfy({ $0.isNumber })
    }
}

