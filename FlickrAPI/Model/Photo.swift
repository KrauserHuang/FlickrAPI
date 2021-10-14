//
//  Photo.swift
//  FlickrAPI
//
//  Created by Tai Chin Huang on 2021/10/13.
//

import Foundation

struct SearchData: Codable {
    let photos: PhotoData
}

struct PhotoData: Codable {
    let photo: [Photo]
}

struct Photo: Codable {
    let server: String
    let id: String
    let secret: String
    
    var imageUrl: URL {
        return URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secret).jpg")!
    }
}
