//
//  ProductsViewModel.swift
//  LifetechTest
//
//  Created by Victor on 3/18/21.
//

import Foundation
import UIKit
import CoreData

class ProductsViewModel: NSObject {
    // MARK: - Properties
    var apiService: APIService!
    private(set) var productsData : Products! = Products(products: [Product]())
    {
        didSet {
            self.bindProductsViewModelToController()
        }
    }
    var products: [ProductData] = []
    
    // MARK: - Closures
        
        // Through these closures, our view model will execute code while some events will occure
        // They will be set up by the view controller
    var reloadTableViewClosure: (()->())?
    var bindProductsViewModelToController : (() -> ()) = {}
    
    // MARK: - Constructor
    override init() {
        super.init()
        configureCacheDirectory()
        self.apiService = APIService()
        if Reachability.isConnectedToNetwork() {
            callFuncToGetProductsData()
        }
        else {
            getProductsFromCoreData()
        }
    }
    
    // MARK: - Functions
    fileprivate func configureCacheDirectory() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("productsImages")

        if !FileManager.default.fileExists(atPath: path.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Cannot create directory: \(path.absoluteString)")
            }
        }
    }
    
    fileprivate func addDataToCoreData() {
        DispatchQueue.main.async {
            for product in self.productsData.products {
                
                var nonExistingProduct = 0
                for i in self.products {
                    if product.product_id != i.product_id{
                        nonExistingProduct += 1
                    }
                    else { break }
                }
                if nonExistingProduct == self.products.count {
                    self.saveToContext(product: product)
                }
            }
        }
    }
    
    fileprivate func callFuncToGetProductsData() {
        self.apiService.getProductsData { (productsData, error) in
            guard error == nil else { print("\(String(describing: error?.localizedDescription))"); return}
            
            for product in productsData!.products {
                self.apiService.getProductImage(product: product) { (name, image, error) in
                    if ImageCache.shared.imageDictionary[name] == nil {
                        ImageCache.shared.imageDictionary[name] = image
                        image.saveImage(name: name, filePath: ImageCache.path.appendingPathComponent(name))
                        self.reloadTableViewClosure?()
                    }
                }
            }
            self.productsData = productsData
            self.fetchFromContext()
            self.addDataToCoreData()
            
        }
    }
    
    fileprivate func getProductsFromCoreData() {
        fetchFromContext()
        DispatchQueue.main.async {
            var cachedProducts = Products(products: [Product]())
            for product in self.products {
                if let id = product.product_id,
                   let name = product.name,
                   let image = product.image {
                    let newProduct = Product(product_id: id, name: name,
                                             price: Int(product.price), image: image)
                    cachedProducts.products.append(newProduct)
                }
            }
            self.productsData = cachedProducts
        }
    }
    
    fileprivate func saveToContext(product: Product) {
        
        DispatchQueue.main.async {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ProductData", in: managedContext)!
            
            let productData = NSManagedObject(entity: entity, insertInto: managedContext)
            
            productData.setValue(product.image, forKeyPath: "image")
            productData.setValue(product.name, forKeyPath: "name")
            productData.setValue(product.price, forKey: "price")
            productData.setValue(product.product_id, forKey: "product_id")
            
            do {
                try managedContext.save()
                self.products.append(productData as! ProductData)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    fileprivate func fetchFromContext() {
        DispatchQueue.main.async {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductData")

            do {
                self.products = try managedContext.fetch(fetchRequest) as! [ProductData]
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
   
}
