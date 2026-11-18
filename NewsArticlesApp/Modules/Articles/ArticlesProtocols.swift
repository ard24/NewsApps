//
//  ArticlesProtocols.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import UIKit

protocol ArticlesViewToPresenterProtocol: AnyObject {
    var view: ArticlesPresenterToViewProtocol? { get set }
    var interactor: ArticlesPresenterToInteractorProtocol? { get set }
    var router: ArticlesPresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
    func searchArticles(query: String)
    func loadNextPage()
    func didSelectArticle(_ article: Article)
}

protocol ArticlesPresenterToViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showBottomSpinner(_ show: Bool)
    func showArticles(_ articles: [Article])
    func showEmptyState(_ message: String)
    func showError(_ message: String)
}

protocol ArticlesPresenterToInteractorProtocol: AnyObject {
    var presenter: ArticlesInteractorToPresenterProtocol? { get set }
    func fetchArticles(source: ArticleSource, query: String, page: Int, pageSize: Int)
}

protocol ArticlesInteractorToPresenterProtocol: AnyObject {
    func didFetchArticles(_ articles: [Article], totalResults: Int, isFirstPage: Bool)
    func didFailToFetchArticles(with error: Error, isFirstPage: Bool)
}

protocol ArticlesPresenterToRouterProtocol: AnyObject {
    static func createModule(source: ArticleSource) -> UIViewController
    func navigateToWebView(from view: ArticlesPresenterToViewProtocol?, article: Article)
}
