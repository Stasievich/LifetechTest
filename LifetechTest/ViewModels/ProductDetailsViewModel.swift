//
//  ProductDetailsViewModel.swift
//  LifetechTest
//
//  Created by Victor on 3/18/21.
//

import Foundation
import CoreData
import UIKit

class ProductDetailsViewModel: NSObject {
    
    // MARK: - Properties
    var apiService: APIService!
    private(set) var productDetailsData : ProductDetails!  {
            didSet {
                self.bindProductDetailsViewModelToController()
            }
        }
    var productDetails: [ProductDetailsData] = []
    
    // MARK: - Closures
        
        // Through these closures, our view model will execute code while some events will occure
        // They will be set up by the view controller
    var bindProductDetailsViewModelToController : (() -> ()) = {}
    
    // MARK: - Constructor
    init(productId: String) {
        super.init()
        self.apiService = APIService()
        if Reachability.isConnectedToNetwork() {
            callFuncToGetProductDetailsData(id: productId)
        }
        else {
            getProductDetailsFromCoreData(id: productId)
        }
    }
    // MARK: - Functions
    fileprivate func callFuncToGetProductDetailsData(id: String) {
        self.apiService.getProductDetailsData(id: id) { (productDetailsData) in
            self.productDetailsData = productDetailsData
            self.fetchFromContext()
            self.addDataToCoreData()
        }
    }
    
    fileprivate func addDataToCoreData() {
        DispatchQueue.main.async {
            var nonExistingProduct = 0
            for productDetails in self.productDetails {
                if self.productDetailsData.product_id != productDetails.product_id{
                    nonExistingProduct += 1
                }
                else { break }
            }
            if nonExistingProduct == self.productDetails.count {
                self.saveData(product: self.productDetailsData)
            }
        }
    }
    
    fileprivate func getProductDetailsFromCoreData(id: String) {
        fetchFromContext()
        DispatchQueue.main.async {
            for product in self.productDetails {
                if product.product_id == id {
                    if let id = product.product_id,
                       let name = product.name,
                       let image = product.image,
                       let description = product.productDescription {
                        let newProduct = ProductDetails(product_id: id as String, name: name as String, price: Int(product.price as Int64), image: image as String, description: description as String)
                        self.productDetailsData = newProduct
                    }
                    break
                }
            }
        }
    }
    
    fileprivate func saveData(product: ProductDetails) {
        
        DispatchQueue.main.async {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ProductDetailsData", in: managedContext)!
            
            let productDetailsData = NSManagedObject(entity: entity, insertInto: managedContext)
            
            productDetailsData.setValue(product.image, forKeyPath: "image")
            productDetailsData.setValue(product.name, forKeyPath: "name")
            productDetailsData.setValue(product.price, forKey: "price")
            productDetailsData.setValue(product.product_id, forKey: "product_id")
            productDetailsData.setValue(product.description, forKey: "productDescription")
            
            do {
                try managedContext.save()
                self.productDetails.append(productDetailsData as! ProductDetailsData)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    fileprivate func fetchFromContext() {
        DispatchQueue.main.async {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductDetailsData")

            do {
                self.productDetails = try managedContext.fetch(fetchRequest) as! [ProductDetailsData]
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
}
