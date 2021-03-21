//
//  APIService.swift
//  LifetechTest
//
//  Created by Victor on 3/18/21.
//

import Foundation
import UIKit

class APIService {
    
    func getProductsData(completion: @escaping (Products?, Error?) -> ()) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "s3-eu-west-1.amazonaws.com"
        components.path = "/developer-application-test/cart/list"
        
        guard let url = components.url else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, urlResponse, error) in
            if (error != nil) {
                print(String(describing: error))
            }
            else {
                if let data = data {
                
                    do {
                    let jsonDecoder = JSONDecoder()
                
                    let productsData = try jsonDecoder.decode(Products.self, from: data)
                    completion(productsData, error)
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }.resume()
    }
    
    func getProductImage(product: Product, completion: @escaping (String, UIImage, Error?) -> ()) {
        
        let imageURL = URL(string: product.image)
        guard let url = imageURL else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, urlResponse, error) in
            if (error != nil) {
                print(String(describing: error))
            }
            else {
                guard let data = data else { return }
                if let data = UIImage(data: data) {
                
                    completion(product.name, data, error)
                }
            }
        }.resume()
    }
    
    func getProductDetailsData(id: String, completion: @escaping (ProductDetails) -> ()) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "s3-eu-west-1.amazonaws.com"
        components.path = "/developer-application-test/cart/\(id)/detail"
        
        guard let url = components.url else { return }
        URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            if let data = data {
                
                do {
                    let jsonDecoder = JSONDecoder()
                
                    let productDetailsData = try jsonDecoder.decode(ProductDetails.self, from: data)
                    completion(productDetailsData)
                }
                catch {
                    print(error)
                }
            }
        }.resume()
    }
}
