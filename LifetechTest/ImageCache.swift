//
//  ImageCache.swift
//  LifetechTest
//
//  Created by Victor on 3/20/21.
//

import Foundation
import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    private init() {}
    
    static var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("productsImages")
    
    var imageDictionary: [String: UIImage] = {
        var imgDict = [String: UIImage]()
        do{
            
            let names = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            
            imgDict = names.reduce([String: UIImage]()) { (dict, name) -> [String: UIImage] in
                var dict = dict
                do {
                    let productName = name.lastPathComponent
                    let data = try Data(contentsOf: path.appendingPathComponent(productName))
                    dict[productName] = UIImage(data: data)
                }
                catch {
                    print("Error while enumerating files : \(error.localizedDescription)")
                }
                return dict
            }
        }
        catch {
            print("There is no path: \(path)")
        }
        
        return imgDict
    }()
}
