//
//  MyRecentlyDogsViewController.swift
//  Redog
//
//  Created by Srinivas on 04/05/24.
//

import UIKit

class MyRecentlyDogsViewController: UIViewController {
    
    let cacheURLs = LRUCache.shared.getCachedURLs()
    @IBOutlet weak var dogCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func clearDogsButtonAction(_ sender: Any) {
        LRUCache.shared.clearCache()
        navigationController?.popViewController(animated: true)
    }
    
    func setupUI(){
        title = "My Recently Generated Dogs!"
        dogCollectionView.setCollectionViewLayout(createCompositionalLayout(), animated: true)
        dogCollectionView.translatesAutoresizingMaskIntoConstraints = false
        dogCollectionView.delegate = self
        dogCollectionView.dataSource = self
        dogCollectionView.registerNib(MyRecentDogsCollectionViewCell.self)
        dogCollectionView.showsHorizontalScrollIndicator = false
        dogCollectionView.showsVerticalScrollIndicator = false
        dogCollectionView.isPagingEnabled = false
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _ ) -> NSCollectionLayoutSection? in
            
            let groupWidthDimension: CGFloat =  1.0
            let groupHeightDimension: CGFloat =  0.9
            
            let itemWidthDimension: CGFloat =  1.0
            let itemHeightDimension: CGFloat = 1.0
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidthDimension), heightDimension: .fractionalHeight(itemHeightDimension))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 8)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidthDimension), heightDimension: .fractionalHeight(groupHeightDimension))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
            section.orthogonalScrollingBehavior = .paging
            return section
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        dogCollectionView.reloadSections(IndexSet(integer: 0))
    }
    
}

extension MyRecentlyDogsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cacheURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(MyRecentDogsCollectionViewCell.self, for: indexPath)
        
        let url = cacheURLs[indexPath.item]
        
        if let imageData = LRUCache.shared.getImageData(for: url) {
            cell.configureCellWithData(imageData: imageData)
        }
        
        return cell
        
    }
}
