//
//  AppleStoreItemController.swift
//  AppleSearch
//
//  Created by Trevor Bursach on 9/24/20.
//

//https://itunes.apple.com/search?term=facebook&entity=software

import Foundation
import UIKit.UIImage

struct StringConstants {
    fileprivate static let baseURLString = "https://itunes.apple.com"
    fileprivate static let searchComponent = "search"
    fileprivate static let termQueryName = "term"
    fileprivate static let entityQueryName = "entity"
    fileprivate static let musicEntityQueryValue = "musicTrack"
    fileprivate static let appEntityQueryValue = "software"
    
}

class AppleStoreItemController {
    
    static func fetchMusicItems(searchTerm: String, completion: @escaping (Result<[MusicTrack], AppleStoreError>) -> Void) {
        
        guard let baseURL = URL(string: StringConstants.baseURLString) else { return completion(.failure(.invalidURL)) }
        let searchURL = baseURL.appendingPathComponent(StringConstants.searchComponent)
        
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        let termQuery = URLQueryItem(name: StringConstants.termQueryName, value: searchTerm)
        let entityQuery = URLQueryItem(name: StringConstants.entityQueryName, value: StringConstants.musicEntityQueryValue)
        components?.queryItems = [termQuery, entityQuery]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelDictionary = try JSONDecoder().decode(MusicTopLevelObject.self, from: data)
                let musicItems = topLevelDictionary.results
                return completion(.success(musicItems))
            } catch {
                return completion(.failure(.unableToDecode(error)))
            }
        }.resume()
    }
    
    static func fetchAppItems(searchTerm: String, completion: @escaping (Result<[AppItem], AppleStoreError>) -> Void) {
        
        guard let baseURL = URL(string: StringConstants.baseURLString) else { return completion(.failure(.invalidURL)) }
        let searchURL = baseURL.appendingPathComponent(StringConstants.searchComponent)
        
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        let termQuery = URLQueryItem(name: StringConstants.termQueryName, value: searchTerm)
        let entityQuery = URLQueryItem(name: StringConstants.entityQueryName, value: StringConstants.appEntityQueryValue)
        components?.queryItems = [termQuery, entityQuery]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelDictionary = try JSONDecoder().decode(AppTopLevelObject.self, from: data)
                let appItems = topLevelDictionary.results
                return completion(.success(appItems))
            } catch {
                return completion(.failure(.unableToDecode(error)))
            }
        }.resume()
    }
    
    static func fetchImageFrom(url: URL, completion: @escaping (Result<UIImage, AppleStoreError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecodeImage)) }
            return completion(.success(image))
        }.resume()
    }
} // END OF CLASS
