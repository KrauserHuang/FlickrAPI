//
//  FlickrCollectionViewController.swift
//  FlickrAPI
//
//  Created by Tai Chin Huang on 2021/10/13.
//

import UIKit
import SwiftUI

let deviceNames: [String] = [
    "iPhone 13 Pro"
]

struct ViewControllerPreview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> FlickrCollectionViewController {
        UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FlickrCollectionViewController") as! FlickrCollectionViewController
    }
    func updateUIViewController(_ uiViewController: FlickrCollectionViewController, context: Context) {
    }
    typealias UIViewControllerType = FlickrCollectionViewController
}
struct ViewControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview()
    }
}

private let reuseIdentifier = "PhotoCell"

class FlickrCollectionViewController: UICollectionViewController {
    
    var photos = [Photo]()
    var model = PhotoSearchModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        model.fetchSearchData()
        collectionView.collectionViewLayout = createLayout()
        print("viewDidLoad")
    }
    
    func createLayout() -> UICollectionViewLayout {
        let padding: Double = 2
        
        let singleItem = NSCollectionLayoutItem(
            /*
             NSCollectionLayoutSize用來判斷與所屬容器的比例關係
             這裡singleItem對應所屬是singleDoubleHorizontalGroup
             他的寬是group的2/3倍，高是1倍
             */
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1)
            )
        )
        singleItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding/2, bottom: 0, trailing: padding/2)
        
        // 對應doubleVerticalGroup，由於有count:2幫你計算doubleItem比例，所以不用特別定義比例，填(1)即可
        let doubleItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let doubleVerticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            ),
            subitem: doubleItem, count: 2
        )
        // 使用contentInsets會先裁切邊距完在計算fractional比例，在group的item裡再使用interItemSpacing
        doubleVerticalGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding/2, bottom: 0, trailing: padding/2)
        doubleVerticalGroup.interItemSpacing = .fixed(padding)
        
        let singleDoubleHorizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(2/3)
            ),
            subitems: [singleItem, doubleVerticalGroup]
        )
        singleDoubleHorizontalGroup.contentInsets = NSDirectionalEdgeInsets(top: padding/2, leading: 0, bottom: padding/2, trailing: 0)
//        singleDoubleHorizontalGroup.interItemSpacing = .fixed(padding)
        
        let tripleItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding/2, bottom: 0, trailing: padding/2)
        
        let tripleHorizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1/3)
            ),
            subitem: tripleItem, count: 3
        )
        tripleHorizontalGroup.contentInsets = NSDirectionalEdgeInsets(top: padding/2, leading: 0, bottom: padding/2, trailing: 0)
//        tripleHorizontalGroup.interItemSpacing = .fixed(padding)
        
        let baseVerticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            ),
            subitems: [singleDoubleHorizontalGroup, tripleHorizontalGroup]
        )
        let section = NSCollectionLayoutSection(group: baseVerticalGroup)
//        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
//        section.interGroupSpacing = padding
        return UICollectionViewCompositionalLayout(section: section)
    }
    // MARK: UICollectionViewDataSource
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 0
//    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Total: \(photos.count)")
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("Fail to dequeue PhotoCell")
        }
    
        let photo = photos[indexPath.item]
        cell.displayPhoto(photo)
    
        return cell
    }
}

extension FlickrCollectionViewController: PhotoSearchDelegate {
    func searchPhotoRetrieved(_ photos: [Photo]) {
        self.photos = photos
        collectionView.reloadData()
    }
}
