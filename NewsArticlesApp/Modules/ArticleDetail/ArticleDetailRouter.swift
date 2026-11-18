//
//  ArticleDetailRouter.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import UIKit

final class ArticleDetailRouter: ArticleDetailPresenterToRouterProtocol {
    static func createModule(article: Article) -> UIViewController {
        let view = ArticleDetailViewController()
        let presenter = ArticleDetailPresenter(article: article)
        
        view.navigationItem.title  = article.source.name
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
