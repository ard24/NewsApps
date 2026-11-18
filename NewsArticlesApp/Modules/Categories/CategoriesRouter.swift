//
//  CategoriesRouter.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import UIKit

final class CategoriesRouter: CategoriesPresenterToRouterProtocol {
    static func createModule() -> UIViewController {
        let view = CategoriesViewController()
        let presenter = CategoriesPresenter()
        let router = CategoriesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        return view
    }
    
    func navigateToSources(from view: CategoriesPresenterToViewProtocol?, category: NewsCategory) {
        let sourcesVC = SourcesRouter.createModule(category: category)
        if let sourceController = view as? UIViewController {
            sourceController.navigationController?.pushViewController(sourcesVC, animated: true)
        }
    }
}
