//
//  SourcesProtocols.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import UIKit

protocol SourcesViewToPresenterProtocol: AnyObject {
    var view: SourcesPresenterToViewProtocol? { get set }
    var interactor: SourcesPresenterToInteractorProtocol? { get set }
    var router: SourcesPresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
    func searchSources(query: String)
    func loadNextPage()
    func didSelectSource(_ source: ArticleSource)
}

protocol SourcesPresenterToViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showBottomSpinner(_ show: Bool)
    func showSources(_ sources: [ArticleSource])
    func showEmptyState(_ message: String)
    func showError(_ message: String)
}

protocol SourcesPresenterToInteractorProtocol: AnyObject {
    var presenter: SourcesInteractorToPresenterProtocol? { get set }
    func fetchTopHeadlines(country: String, category: String, page: Int, pageSize: Int)
}

protocol SourcesInteractorToPresenterProtocol: AnyObject {
    func didFetchArticles(_ articles: [Article], totalResults: Int, isFirstPage: Bool)
    func didFailToFetchArticles(with error: Error, isFirstPage: Bool)
}

protocol SourcesPresenterToRouterProtocol: AnyObject {
    static func createModule(category: NewsCategory) -> UIViewController
    func navigateToArticles(from view: SourcesPresenterToViewProtocol?, source: ArticleSource)
}
