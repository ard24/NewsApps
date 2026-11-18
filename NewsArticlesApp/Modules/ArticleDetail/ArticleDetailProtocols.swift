//
//  ArticleDetailProtocols.swift
//  NewsArticlesApp
//
//  Created by MacBook on 18/11/26.
//

import UIKit

protocol ArticleDetailViewToPresenterProtocol: AnyObject {
    var view: ArticleDetailPresenterToViewProtocol? { get set }
    func viewDidLoad()
}

protocol ArticleDetailPresenterToViewProtocol: AnyObject {
    func loadURL(_ url: URL)
    func showError(_ message: String)
}

protocol ArticleDetailPresenterToRouterProtocol: AnyObject {
    static func createModule(article: Article) -> UIViewController
}
