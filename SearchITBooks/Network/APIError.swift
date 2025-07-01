//
//  APIError.swift
//  SearchITBooks
//
//  Created by Regina on 6/29/25.
//

import Foundation

enum APIError: Error, LocalizedError {
	case invalidURL
	case decodingFailed
	case error(String)
	case noData
	
	var errorDescription: String? {
		switch self {
		case .invalidURL:
			return "Invalid URL"
		case .decodingFailed:
			return "Decoding failed"
		case .error(let msg):
			return "Error occurred: \(msg)"
		case .noData:
			return "No data"
		}
	}
}
