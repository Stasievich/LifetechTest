//
//  Product.swift
//  LifetechTest
//
//  Created by Victor on 3/18/21.
//

import Foundation

struct Products: Decodable {
    var products: [Product]
}

struct Product: Decodable {
    var product_id: String
    var name: String
    var price: Int
    var image: String
}

struct ProductDetails: Decodable {
    var product_id: String
    var name: String
    var price: Int
    var image: String
    var description: String?
}
