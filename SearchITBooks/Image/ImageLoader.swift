//
//  ImageLoader.swift
//  SearchITBooks
//
//  Created by Regina on 6/30/25.
//
import UIKit

final class ImageLoader {
	static let shared = ImageLoader()
	private init() {}
	
	func load(from urlString: String) async -> UIImage? {
		if let cached = ImageCache.shared.image(forKey: urlString) {
			return cached
		}
		
		guard let url = URL(string: urlString) else { return nil }
		
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			if let image = UIImage(data: data) {
				ImageCache.shared.store(image: image, forKey: urlString)
				return image
			}
		} catch {
			print("이미지 로딩 실패: \(error)")
		}
		return nil
	}
}
