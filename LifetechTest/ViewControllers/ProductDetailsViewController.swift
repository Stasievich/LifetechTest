//
//  ProductDetailsViewController.swift
//  LifetechTest
//
//  Created by Victor on 3/18/21.
//

import Foundation
import UIKit

class ProductDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var productDetailsViewModel: ProductDetailsViewModel!
    
    var productId = String()
    var imageName = String()
    var productImage = UIImageView()
    var productName = UILabel()
    var productPrice = UILabel()
    var productDescription = UITextView()
    var containerView = UIScrollView()
      
    // MARK: - Overrided Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureContainerView()
        configureProductImage()
        configureProductName()
        configureProductDescription()
        
        resizeTextView(textView: productDescription)
        
        callToViewModelForUIUpdate()
    }
    
    // MARK: - Functions
    fileprivate func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 15
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.backgroundColor = .green
        containerView.showsVerticalScrollIndicator = false
        view.addSubview(containerView)
        
        view.addConstraints([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    fileprivate func configureProductImage() {
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.contentMode = .scaleAspectFill
        productImage.clipsToBounds = true
        containerView.addSubview(productImage)
        
        containerView.addConstraints([
            productImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            productImage.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            productImage.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    fileprivate func configureProductName() {
        productName.translatesAutoresizingMaskIntoConstraints = false
        productName.font = UIFont(name: "GillSans-Bold", size: 20)
        productName.numberOfLines = 0
        containerView.addSubview(productName)
        
        containerView.addConstraints([
            productName.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 20),
            productName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            productName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30)
        ])
    }
    
    fileprivate func configureProductDescription() {
        productDescription.translatesAutoresizingMaskIntoConstraints = false
        productDescription.font = UIFont(name: "GillSans", size: 17)
        productDescription.backgroundColor = .green
        productDescription.isScrollEnabled = false
        productDescription.isEditable = false
        containerView.addSubview(productDescription)
        
        containerView.addConstraints([
            productDescription.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 20),
            productDescription.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            productDescription.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            productDescription.bottomAnchor.constraint(equalTo: containerView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    fileprivate func resizeTextView(textView: UITextView) {
        var newFrame = textView.frame
        let width = newFrame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: width, height: newSize.height)
        textView.frame = newFrame
    }
    
    func callToViewModelForUIUpdate() {
        self.productDetailsViewModel = ProductDetailsViewModel(productId: productId)
        self.productDetailsViewModel.bindProductDetailsViewModelToController = {
            self.updateDataSource()
        }
        self.productImage.image = ImageCache.shared.imageDictionary[self.imageName]
    }
    
    func updateDataSource() {
        DispatchQueue.main.async {
            
            if let productDetails = self.productDetailsViewModel.productDetailsData {
                
                self.productName.text = productDetails.name
                self.productDescription.text = productDetails.description
            }
        }
    }
}
