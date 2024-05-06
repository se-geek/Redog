//
//  ViewController.swift
//  Redog
//
//  Created by Srinivas on 04/05/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onGenerateButtonClickAction(_ sender: UIButton) {
        
        let genrateDogsVC = Storyboard.main.instantiateVC(GenerateDogsViewController.self)
        navigationController?.pushViewController(genrateDogsVC, animated: true)
    }
    
    
    @IBAction func onMyRecentDogsButtonClickAction(_ sender: Any) {
        let myRecentDogsVC = Storyboard.main.instantiateVC(MyRecentlyDogsViewController.self)
        navigationController?.pushViewController(myRecentDogsVC, animated: true)
        
    }
    
    
}

