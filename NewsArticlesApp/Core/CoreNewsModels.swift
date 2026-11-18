//
//  CoreNewsModels.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case noData
    case apiError(String)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noData: return "No data ."
        case .apiError(let message): return message
        case .decodingError: return "Error"
        }
    }
}

struct NewsRequestParams {
    var parameters: [String: String]
    
    init(_ parameters: [String: String] = [:]) {
        self.parameters = parameters
    }
    
    func toQueryItems(apiKey: String) -> [URLQueryItem] {
        var items = parameters
            .filter { !$0.value.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { URLQueryItem(name: $0.key, value: $0.value) }
        items.append(URLQueryItem(name: "apiKey", value: apiKey))
        return items
    }
}

enum NewsCategory: String, CaseIterable {
    case business, entertainment, general, health, science, sports, technology
    
    var displayName: String {
        rawValue
    }
}

struct NewsResponse: Codable {
    let status: String
    let message: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article: Codable, Equatable {
    let source: ArticleSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}

struct ArticleSource: Codable, Equatable {
    let id: String?
    let name: String
}

protocol NewsAPIServiceProtocol {
    func request<T: Decodable>(endpoint: String, params: NewsRequestParams, completion: @escaping (Result<T, Error>) -> Void)
}

final class NewsAPIService: NewsAPIServiceProtocol {
    static let shared = NewsAPIService()
    private let apiKey = "9b55798578604a6a90b73efa1b47a1f6"
    
    private init() {}
    
    func request<T: Decodable>(endpoint: String, params: NewsRequestParams, completion: @escaping (Result<T, Error>) -> Void) {
        guard var components = URLComponents(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        components.queryItems = params.toQueryItems(apiKey: apiKey)
        
        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let status = json["status"] as? String, status == "error" {
                    let message = json["message"] as? String ?? "Something Wrong"
                    completion(.failure(NetworkError.apiError(message)))
                    return
                }
                
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}
