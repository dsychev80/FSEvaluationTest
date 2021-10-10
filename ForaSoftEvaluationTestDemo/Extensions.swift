//
//  Extensions.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/9/21.
//

import UIKit

protocol Nameable: AnyObject {
    static var name: String { get }
}

extension Nameable {
    static var name: String {
        return String(describing: self)
    }
}

extension UIViewController: Nameable { }

extension UIStoryboard {
    func instantiateViewController<VC: UIViewController>(withClass viewControllerClass: VC.Type) -> VC {
        return instantiateViewController(identifier: VC.name) as! VC
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension Date {
    /// Convert Date to String with formate "dd.MM.YYYY"
    func formate() -> String {
        let dateFormaterr = DateFormatter()
        dateFormaterr.dateFormat = "dd.MM.YYYY"
        return dateFormaterr.string(from: self)
    }
}
