//
//  SourcesRouter.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import UIKit

final class SourcesRouter: SourcesPresenterToRouterProtocol {
    static func createModule(category: NewsCategory) -> UIViewController {
        let view = SourcesViewController()
        let presenter = SourcesPresenter(category: category)
        let interactor = SourcesInteractor()
        let router = SourcesRouter()
        
        view.navigationItem.title  = category.displayName
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        return view
    }
    
    func navigateToArticles(from view: SourcesPresenterToViewProtocol?, source: ArticleSource) {
        let articlesVC = ArticlesRouter.createModule(source: source)
        if let sourceController = view as? UIViewController {
            sourceController.navigationController?.pushViewController(articlesVC, animated: true)
        }
    }
}
