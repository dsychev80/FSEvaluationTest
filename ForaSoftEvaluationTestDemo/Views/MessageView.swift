//
//  MessageView.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/12/21.
//

import UIKit


class MessageView: UIView {
    
    private struct Constants {
        static let defaultMessage = "Please enter the name of artist you are interested in"
    }

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            xibLoading()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            xibLoading()
        }

        func xibLoading() {
            Bundle.main.loadNibNamed(MessageView.name, owner: self, options: nil)

            view.frame = bounds
            view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(view)
        }
    
    func configure(with message: String) {
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text = message
        view.addSubview(messageLabel)
    }
}
