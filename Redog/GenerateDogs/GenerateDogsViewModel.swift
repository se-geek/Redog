//
//  GenerateDogsViewModel.swift
//  Redog
//
//  Created by Srinivas on 04/05/24.
//

import Foundation

protocol GenerateDogsViewModelDelegate: AnyObject {
    func showLoader(show: Bool)
    func showAlert(message: String)
    func updateImage(imageData: Data)
    
}

class GenerateDogsViewModel {
    
    weak var delegate: GenerateDogsViewModelDelegate?
    var dogsResponse: GenerateDogsModel?
    
    init(delegate: GenerateDogsViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func getDogImage() {
        delegate?.showLoader(show: true)
        APIRequester().getDogImages(for: .getDogs) { (result, response) in
            switch result {
            case .success(let response):
                if let status = response?.status, status == "success", let imageString = response?.message, let imageURL = URL(string: imageString)  {
                    DispatchQueue.global().async {
                        if let imageData = try? Data(contentsOf: imageURL) {
                            DispatchQueue.main.async {
                                self.delegate?.updateImage(imageData: imageData)
                                LRUCache.shared.setImageData(imageData, for: imageURL)
                            }
                        } else {
                            self.delegate?.showAlert(message: "Failed to fetch image data from URL")
                        }
                    }
                }
                self.delegate?.showLoader(show: false)
            case .failure(let failure):
                self.delegate?.showAlert(message: failure.localizedDescription)
            }
        }
        LRUCache.shared.printCacheURLs()
    }
    
    
}


