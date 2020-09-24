//
//  AppleStoreError.swift
//  AppleSearch
//
//  Created by Trevor Bursach on 9/24/20.
//

import Foundation

enum AppleStoreError: LocalizedError {
    
    case invalidURL
    case noData
    case thrownError(Error)
    case unableToDecode(Error)
    case unableToDecodeImage
    
    
}
