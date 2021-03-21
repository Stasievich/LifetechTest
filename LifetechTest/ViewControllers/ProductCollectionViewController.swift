//
//  ViewController.swift
//  LifetechTest
//
//  Created by Victor on 3/18/21.
//

import UIKit

class ProductCollectionViewController: UIViewController {
    
    // MARK: - Properties
    var productViewModel: ProductsViewModel!

    lazy var productsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIDevice.current.orientation.isLandscape ? landscapeLayout : portraitLayout)
    var portraitLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let rowSize = UIScreen.main.bounds.width
        let inset: CGFloat = 5
        let numberOfItemsInRow: CGFloat = 2
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let itemWidth = (rowSize - inset * (numberOfItemsInRow + 1)) / numberOfItemsInRow
        layout.itemSize = CGSize(width: itemWidth,
                                 height: itemWidth)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        return layout
    }()
    var landscapeLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let rowSize = UIScreen.main.bounds.height
        let inset: CGFloat = 5
        let numberOfItemsInRow: CGFloat = 4
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let itemWidth = (rowSize - inset * (numberOfItemsInRow + 1)) / numberOfItemsInRow
        layout.itemSize = CGSize(width: itemWidth,
                                 height: itemWidth)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        return layout
    }()
    let reuseId = "cell"
    
    // MARK: - Overrided Functions
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            productsCollectionView.setCollectionViewLayout(landscapeLayout, animated: true)
        } else {
            productsCollectionView.setCollectionViewLayout(portraitLayout, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        callToViewModelForUIUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func loadView() {
        super.loadView()
        configureCollectionView()
        
    }
    
    // MARK: - Functions
    func callToViewModelForUIUpdate() {
        productViewModel = ProductsViewModel()
        
        self.productViewModel.bindProductsViewModelToController = {
            self.updateDataSource()
        }
        
        self.productViewModel.reloadTableViewClosure = { [weak self] () in
           DispatchQueue.main.async {
              self?.productsCollectionView.reloadData()
           }
        }
    }
    
    func updateDataSource() {
        DispatchQueue.main.async {
            self.productsCollectionView.dataSource = self
            self.productsCollectionView.register(ProductsCollectionViewCell.self,
                                                 forCellWithReuseIdentifier: self.reuseId)
            self.productsCollectionView.delegate = self
            self.productsCollectionView.reloadData()
        }
    }
    
    func configureCollectionView() {
        view.addSubview(productsCollectionView)
        productsCollectionView.fillView(view)
        productsCollectionView.backgroundColor = .green
        productsCollectionView.showsVerticalScrollIndicator = false
    }
}

// MARK: - Extensions
extension ProductCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productViewModel.productsData.products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! ProductsCollectionViewCell
        cell.backgroundColor = .white
        
        let product = productViewModel.productsData.products[indexPath.row]
        
        cell.productImage.image = ImageCache.shared.imageDictionary[product.name]
        cell.productName.text = product.name
        cell.productPrice.text = String(product.price)
        
        return cell
    }

}

extension ProductCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsVC = ProductDetailsViewController()
        productDetailsVC.productId = productViewModel.productsData.products[indexPath.row].product_id
        navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    
}
