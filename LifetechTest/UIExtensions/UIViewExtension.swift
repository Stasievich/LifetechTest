//
//  UIViewExtension.swift
//  LifetechTest
//
//  Created by Victor on 3/18/21.
//

import Foundation
import UIKit

extension UIView {
    
    func fillView(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
