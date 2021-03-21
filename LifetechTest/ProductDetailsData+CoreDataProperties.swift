//
//  ProductDetailsData+CoreDataProperties.swift
//  LifetechTest
//
//  Created by Victor on 3/19/21.
//
//

import Foundation
import CoreData


extension ProductDetailsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductDetailsData> {
        return NSFetchRequest<ProductDetailsData>(entityName: "ProductDetailsData")
    }

    @NSManaged public var product_id: String?
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var price: Int64
    @NSManaged public var productDescription: String?
    @NSManaged public var product: ProductData?

}

extension ProductDetailsData : Identifiable {

}
