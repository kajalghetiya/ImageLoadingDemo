import Foundation
import UIKit

class LazyImageView: UIImageView
{

    func loadImage(fromURL imageURL: String, placeHolderImage: String)
    {
        self.image = UIImage(named: placeHolderImage)
        ImageCache.shared.getImage(url: imageURL) { image in
            if let image = image {
                // Use the image
                self.image = image
            } else {
                // Image not found or failed to download
                self.image = UIImage(named: "no_found")
            }
        }
    }
}
