//
//  SourcesPresenter.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import Foundation

final class SourcesPresenter: SourcesViewToPresenterProtocol, SourcesInteractorToPresenterProtocol {
    weak var view: SourcesPresenterToViewProtocol?
    var interactor: SourcesPresenterToInteractorProtocol?
    var router: SourcesPresenterToRouterProtocol?
    
    private let category: NewsCategory
    private let country = "us"
    private var uniqueSources: [ArticleSource] = []
    private var seenSourceNames = Set<String>()
    private var filteredSources: [ArticleSource] = []
    
    private var currentPage = 1
    private let pageSize = 20
    private var totalResults = 0
    private var loadedArticlesCount = 0
    private var isFetching = false
    private var currentSearchQuery = ""
    
    init(category: NewsCategory) {
        self.category = category
    }
    
    func viewDidLoad() {
        resetAndFetch()
    }
    
    func searchSources(query: String) {
        currentSearchQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        applySearchFilter()
    }
    
    func loadNextPage() {
        let maxAllowed = min(totalResults, 100)
        guard !isFetching, loadedArticlesCount < maxAllowed else { return }
        
        isFetching = true
        currentPage += 1
        view?.showBottomSpinner(true)
        interactor?.fetchTopHeadlines(country: country, category: category.rawValue, page: currentPage, pageSize: pageSize)
    }
    
    func didSelectSource(_ source: ArticleSource) {
        router?.navigateToArticles(from: view, source: source)
    }
    
    private func resetAndFetch() {
        isFetching = true
        currentPage = 1
        loadedArticlesCount = 0
        uniqueSources.removeAll()
        seenSourceNames.removeAll()
        
        view?.showLoading()
        interactor?.fetchTopHeadlines(country: country, category: category.rawValue, page: currentPage, pageSize: pageSize)
    }
    
    private func applySearchFilter() {
        if currentSearchQuery.isEmpty {
            filteredSources = uniqueSources
        } else {
            filteredSources = uniqueSources.filter {
                $0.name.localizedCaseInsensitiveContains(currentSearchQuery)
            }
        }
        
        if filteredSources.isEmpty {
            view?.showSources([])
            let msg = currentSearchQuery.isEmpty
                ? "This News category is empty"
                : "\"\(currentSearchQuery)\" not found."
            view?.showEmptyState(msg)
        } else {
            view?.showSources(filteredSources)
        }
    }
    
    func didFetchArticles(_ articles: [Article], totalResults: Int, isFirstPage: Bool) {
        DispatchQueue.main.async {
            self.isFetching = false
            self.view?.hideLoading()
            self.view?.showBottomSpinner(false)
            
            self.totalResults = totalResults
            self.loadedArticlesCount += articles.count
            
            for article in articles {
                if self.seenSourceNames.insert(article.source.name).inserted {
                    self.uniqueSources.append(article.source)
                }
            }
            
            self.applySearchFilter()
        }
    }
    
    func didFailToFetchArticles(with error: Error, isFirstPage: Bool) {
        DispatchQueue.main.async {
            self.isFetching = false
            self.view?.hideLoading()
            self.view?.showBottomSpinner(false)
            
            if isFirstPage {
                self.view?.showEmptyState("Gagal memuat sumber berita.")
            }
            self.view?.showError(error.localizedDescription)
        }
    }
}
