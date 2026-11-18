//
//  ArticlesPresenter.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import Foundation

final class ArticlesPresenter: ArticlesViewToPresenterProtocol, ArticlesInteractorToPresenterProtocol {
    weak var view: ArticlesPresenterToViewProtocol?
    var interactor: ArticlesPresenterToInteractorProtocol?
    var router: ArticlesPresenterToRouterProtocol?
    
    private let source: ArticleSource
    private var articles: [Article] = []
    private var currentPage = 1
    private let pageSize = 20
    private var totalResults = 0
    private var isFetching = false
    private var currentQuery = ""
    private var searchDebounceTimer: Timer?
    
    init(source: ArticleSource) {
        self.source = source
    }
    
    func viewDidLoad() {
        resetAndFetch()
    }
    
    func searchArticles(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed != currentQuery else { return }
        currentQuery = trimmed
        
        searchDebounceTimer?.invalidate()
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.resetAndFetch()
        }
    }
    
    func loadNextPage() {
        let maxAllowed = min(totalResults, 100)
        guard !isFetching, articles.count < maxAllowed else { return }
        
        isFetching = true
        currentPage += 1
        view?.showBottomSpinner(true)
        interactor?.fetchArticles(source: source, query: currentQuery, page: currentPage, pageSize: pageSize)
    }
    
    func didSelectArticle(_ article: Article) {
        router?.navigateToWebView(from: view, article: article)
    }
    
    private func resetAndFetch() {
        isFetching = true
        currentPage = 1
        articles = []
        view?.showArticles([])
        view?.showLoading()
        interactor?.fetchArticles(source: source, query: currentQuery, page: currentPage, pageSize: pageSize)
    }
    
    func didFetchArticles(_ newArticles: [Article], totalResults: Int, isFirstPage: Bool) {
        DispatchQueue.main.async {
            self.isFetching = false
            self.view?.hideLoading()
            self.view?.showBottomSpinner(false)
            self.totalResults = totalResults
            
            if isFirstPage {
                self.articles = newArticles
            } else {
                self.articles.append(contentsOf: newArticles)
            }
            
            if self.articles.isEmpty {
                let message = self.currentQuery.isEmpty
                    ? "Articles \(self.source.name) not found."
                    : "Articles \(self.source.name) not found."
                self.view?.showEmptyState(message)
            } else {
                self.view?.showArticles(self.articles)
            }
        }
    }
    
    func didFailToFetchArticles(with error: Error, isFirstPage: Bool) {
        DispatchQueue.main.async {
            self.isFetching = false
            self.view?.hideLoading()
            self.view?.showBottomSpinner(false)
            
            if isFirstPage {
                self.view?.showEmptyState("Gagal memuat artikel.")
            }
            self.view?.showError(error.localizedDescription)
        }
    }
}
