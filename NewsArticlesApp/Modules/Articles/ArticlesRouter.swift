//
//  ArticlesRouter.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import UIKit

final class ArticlesRouter: ArticlesPresenterToRouterProtocol {
    static func createModule(source: ArticleSource) -> UIViewController {
        let view = ArticlesViewController()
        let presenter = ArticlesPresenter(source: source)
        let interactor = ArticlesInteractor()
        let router = ArticlesRouter()
        
        view.navigationItem.title  = source.name
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        return view
    }
    
    func navigateToWebView(from view: ArticlesPresenterToViewProtocol?, article: Article) {
        let webVC = ArticleDetailRouter.createModule(article: article)
        if let sourceController = view as? UIViewController {
            sourceController.navigationController?.pushViewController(webVC, animated: true)
        }
    }
}
