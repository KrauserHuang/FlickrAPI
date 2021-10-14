//
//  PhotoCollectionViewCell.swift
//  FlickrAPI
//
//  Created by Tai Chin Huang on 2021/10/13.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: Photo!
    var model = PhotoSearchModel()
    
//    func downloadImage(url: URL, completionHandler: @escaping (Result<UIImage?, Error>) -> Void) {
//        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//            guard let data = data, error == nil else {
//                completionHandler(.failure(error!))
//                return
//            }
//            if let image = UIImage(data: data) {
//                completionHandler(.success(image))
//                DispatchQueue.main.async {
//                    self?.photoImageView.image = image
//                }
//            } else {
//                completionHandler(.failure(error!))
//            }
//        }.resume()
//    }
    
    func displayPhoto(_ photo: Photo) {
        photoImageView.image = UIImage(systemName: "applelogo")
        self.photo = photo
        
        model.downloadImage(url: photo.imageUrl) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.photoImageView.image = image
                }
            case .failure(let error):
                print("Fail to get image, \(error)")
                DispatchQueue.main.async {
                    self?.photoImageView.image = UIImage(systemName: "xmark.octagon")
                }
            }
        }
    }
}
