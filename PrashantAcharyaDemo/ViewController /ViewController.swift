//
//  ViewController.swift
//  PrashantAcharyaDemo
//
//  Created by Kajal Ghetiya on 17/04/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private let cellIdentifier = "ImageCollCell"
    var cellSpacing = 8.0
    let viewModel = ImageViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        let apiUrl = APPURL.BaseURL +  "limit=100"
        viewModel.sendNetworkRequest(apiUrl: apiUrl) { isStart in
            if isStart {
//                Loader.shared.startAnimatingLoader()
            }else{
//                Loader.shared.stopAnimatingLoader()
            }
        } completionBlock: { errorMsg, isSuceess in
            if isSuceess {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    func registerCell() {
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImageCollCell else {
            return UICollectionViewCell()
        }
        if let thumbnail = viewModel.arrImages?[0].thumbnail {
            var imageUrl = (thumbnail.domain ?? "") + "/"
            imageUrl = imageUrl +  (thumbnail.basePath ?? "") + "/0/" + (thumbnail.key ?? "")
            cell.img.loadImage(fromURL: imageUrl, placeHolderImage: "placeholder")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = (collectionView.frame.size.width - (cellSpacing * 2))/3
        return CGSize(width: round(cellSize), height: round(cellSize))
      }
}

