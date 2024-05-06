//
//  RoundedButton.swift
//  Redog
//
//  Created by Srinivas on 04/05/24.
//

import UIKit

class RoundedBorderButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        layer.cornerRadius = self.frame.height/2
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func roundedCorner(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func circularCorner() {
        self.roundedCorner(radius: self.frame.height/2)
    }
}


extension UICollectionViewCell: Identifiable {}

public protocol Identifiable {
    static var reuseIdentifier: String { get }
}

public extension Identifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


public extension UICollectionView {
    func register(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func registerNib(_ cellClass: UICollectionViewCell.Type) {
        register(UINib(nibName: String(describing: cellClass), bundle: nil), forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeue<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T where T: UICollectionViewCell {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }
    
    func stopScrolling() {
        setContentOffset(contentOffset, animated: false)
    }
}
