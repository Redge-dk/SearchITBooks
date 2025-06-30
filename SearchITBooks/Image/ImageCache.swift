//
//  ImageCache.swift
//  SearchITBooks
//
//  Created by Regina on 6/30/25.
//

import UIKit
import Foundation

final class ImageCache {
	static let shared = ImageCache()
	
	private let cache = NSCache<NSString, UIImage>()
	private let fileManager = FileManager.default
	private lazy var diskCacheURL: URL = {
		let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
		return caches.appendingPathComponent("ImageCache", isDirectory: true)
	}()

	private init() {
		try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
	}

	func image(forKey key: String) -> UIImage? {
		if let image = cache.object(forKey: key as NSString) {
			return image
		}
		let fileURL = diskCacheURL.appendingPathComponent(key.sha1)
		if let data = try? Data(contentsOf: fileURL),
		   let image = UIImage(data: data) {
			cache.setObject(image, forKey: key as NSString)
			return image
		}
		return nil
	}

	func store(image: UIImage, forKey key: String) {
		cache.setObject(image, forKey: key as NSString)
		let fileURL = diskCacheURL.appendingPathComponent(key.sha1)
		if let data = image.pngData() {
			try? data.write(to: fileURL)
		}
	}
	
	func clear() {
		cache.removeAllObjects()
		try? fileManager.removeItem(at: diskCacheURL)
		try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
	}
}

private extension String {
	var sha1: String {
		self.data(using: .utf8)!.base64EncodedString().replacingOccurrences(of: "/", with: "_")
	}
}
