//
//  ProductData+CoreDataProperties.swift
//  LifetechTest
//
//  Created by Victor on 3/19/21.
//
//

import Foundation
import CoreData


extension ProductData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductData> {
        return NSFetchRequest<ProductData>(entityName: "ProductData")
    }

    @NSManaged public var product_id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Int64
    @NSManaged public var image: String?
    @NSManaged public var productDetails: ProductDetailsData?

}

extension ProductData : Identifiable {

}
