//
//  ImageCache.swift
//  PrashantAcharyaDemo
//
//  Created by Kajal Ghetiya on 17/04/24.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private lazy var diskCacheDirectory: URL = {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = urls[urls.count - 1].appendingPathComponent("ImageCache")
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        return cacheDirectory
    }()

    private init() {}

    func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let image = memoryCache.object(forKey: url as NSString) {
            completion(image)
            return
        }

        let fileName = cacheFileName(for: url)
        let fileURL = diskCacheDirectory.appendingPathComponent(fileName)

        if let image = UIImage(contentsOfFile: fileURL.path) {
            // Image found in disk cache, add to memory cache
            memoryCache.setObject(image, forKey: url as NSString)
            completion(image)
            return
        }

        // Image not found in cache, download from URL
        DispatchQueue.global().async {
            if let imageURL = URL(string: url),
               let imageData = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageData) {
                // Save image to disk cache
                try? imageData.write(to: fileURL)
                // Add image to memory cache
                self.memoryCache.setObject(image, forKey: url as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    private func cacheFileName(for url: String) -> String {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_")
        let fileName = url.components(separatedBy: allowedCharacters.inverted).joined()
        return "\(fileName.hash).png"
    }
}
