//
//  UIViewController+.swift
//  SoundClound
//
//  Created by Hai on 6/25/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(message: String, completion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: "Error",
                                   message: message,
                                   preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
}
