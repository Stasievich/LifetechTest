//
//  UIImageExtension.swift
//  LifetechTest
//
//  Created by Victor on 3/20/21.
//

import Foundation
import UIKit

extension UIImage {
    
    func saveImage(name: String, filePath: URL) {
        guard let data = self.jpegData(compressionQuality: 1) ?? self.pngData() else { return }
        do {
            try data.write(to: filePath)
        } catch {
            print(error.localizedDescription)
        }
        return
    }
    
}
