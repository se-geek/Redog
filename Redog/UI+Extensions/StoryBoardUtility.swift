//
//  StoryBoardUtility.swift
//  Redog
//
//  Created by Srinivas on 04/05/24.
//

import Foundation
import UIKit

enum Storyboard: String {
    case main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func instantiateVC<T: UIViewController>(_ objectClass: T.Type) -> T {
        let storyBoard = self.instance
        return storyBoard.instantiateViewController(withIdentifier: objectClass.className) as! T
    }
    
    func instantiateTabbar<T: UITabBarController>(_ objectClass: T.Type) -> T {
        let storyBoard = self.instance
        return storyBoard.instantiateViewController(withIdentifier: objectClass.className) as! T
    }
}

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
}
