//
//  MyRecentDogsCollectionViewCell.swift
//  Redog
//
//  Created by Srinivas on 05/05/24.
//

import UIKit

class MyRecentDogsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWithData(imageData: Data) {
        dogImageView.image = UIImage(data: imageData)
        dogImageView.contentMode = .scaleToFill
    }
    
}
