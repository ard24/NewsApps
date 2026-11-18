//
//  ArticlesInteractor.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import Foundation

final class ArticlesInteractor: ArticlesPresenterToInteractorProtocol {
    weak var presenter: ArticlesInteractorToPresenterProtocol?
    private let apiService: NewsAPIServiceProtocol
    private let endpoint = "https://newsapi.org/v2/top-headlines"
    
    init(apiService: NewsAPIServiceProtocol = NewsAPIService.shared) {
        self.apiService = apiService
    }
    
    func fetchArticles(source: ArticleSource, query: String, page: Int, pageSize: Int) {
        var paramDict: [String: String] = [
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
        
        if let sourceId = source.id, !sourceId.isEmpty {
            paramDict["sources"] = sourceId
            if !query.isEmpty {
                paramDict["q"] = query
            }
        } else {
            paramDict["country"] = "us"
            paramDict["q"] = query.isEmpty ? source.name : "\(source.name) \(query)"
        }
        
        let params = NewsRequestParams(paramDict)
        
        apiService.request(endpoint: endpoint, params: params) { [weak self] (result: Result<NewsResponse, Error>) in
            switch result {
            case .success(let response):
                self?.presenter?.didFetchArticles(
                    response.articles ?? [],
                    totalResults: response.totalResults ?? 0,
                    isFirstPage: page == 1
                )
            case .failure(let error):
                self?.presenter?.didFailToFetchArticles(with: error, isFirstPage: page == 1)
            }
        }
    }
}
