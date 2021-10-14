//
//  PhotoSearchModel.swift
//  FlickrAPI
//
//  Created by Tai Chin Huang on 2021/10/13.
//

import Foundation
import UIKit

protocol PhotoSearchDelegate {
    func searchPhotoRetrieved(_ photos: [Photo])
}

class PhotoSearchModel {
    var delegate: PhotoSearchDelegate?
    
    func fetchSearchData() {
        let api_key = "fdf02d5b6a9ac5bc93dd54be9d259ef5"
        let text = "Cats"
        let per_page = 96
        let max_upload_date = "2021-05-05%2023:59:59"
        let min_upload_date = "2021-01-01%2000:00:00"
        
        let urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(api_key)&text=\(text)&min_upload_date=\(min_upload_date)&max_upload_date=\(max_upload_date)&per_page=\(per_page)&format=json&nojsoncallback=1"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let searchData = try decoder.decode(SearchData.self, from: data)
                let photos = searchData.photos.photo
                DispatchQueue.main.async {
                    self?.delegate?.searchPhotoRetrieved(photos)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func downloadImage(url: URL, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completionHandler(.failure(error!))
                return
            }
            if let image = UIImage(data: data) {
                completionHandler(.success(image))
            } else {
                completionHandler(.failure(error!))
            }
        }.resume()
    }
}
