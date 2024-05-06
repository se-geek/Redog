//
//  GenerateDogsViewController.swift
//  Redog
//
//  Created by Srinivas on 04/05/24.
//

import Foundation
import UIKit

class GenerateDogsViewController: UIViewController {
    
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    var viewModel: GenerateDogsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Generate Dogs!"
        activityLoader.hidesWhenStopped = true
        viewModel = GenerateDogsViewModel(delegate: self)
    }
    
    @IBAction func onGenerateButtonAction(_ sender: Any) {
        viewModel?.getDogImage()
    }
}

extension GenerateDogsViewController: GenerateDogsViewModelDelegate {
  
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alertController.addAction(okAction)
               present(alertController, animated: true, completion: nil)
    }
    
    func updateImage(imageData: Data) {
        self.dogImageView.image = UIImage(data: imageData)
    }
    
    
}
