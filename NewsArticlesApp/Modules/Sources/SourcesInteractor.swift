//
//  SourcesInteractor.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import Foundation

final class SourcesInteractor: SourcesPresenterToInteractorProtocol {
    weak var presenter: SourcesInteractorToPresenterProtocol?
    private let apiService: NewsAPIServiceProtocol
    private let endpoint = "https://newsapi.org/v2/top-headlines"
    
    init(apiService: NewsAPIServiceProtocol = NewsAPIService.shared) {
        self.apiService = apiService
    }
    
    func fetchTopHeadlines(country: String, category: String, page: Int, pageSize: Int) {
        let params = NewsRequestParams([
            "country": country,
            "category": category,
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ])
        
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
