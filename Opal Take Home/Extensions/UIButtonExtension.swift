//
//  StringExtension.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import UIKit
extension UIButton {
    func setAttributedTitle(image: UIImage, text: String, color: UIColor, offset: CGFloat) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: 0, y: offset, width: imageAttachment.image?.size.width ?? 0, height: imageAttachment.image?.size.height ?? 0)
        let attachmentString = NSAttributedString(attachment: imageAttachment)

        let completeText = NSMutableAttributedString(string: "", attributes: [
            .foregroundColor: color,
            .kern: 0.06,
            .font: TextStyle.largeButton.font
        ])
        completeText.append(attachmentString)
        completeText.append(NSAttributedString(string: text))
        completeText.addAttributes([.foregroundColor: color], range: NSRange(location: 0, length: completeText.length))
        setAttributedTitle(completeText, for: .normal)
    }
}
