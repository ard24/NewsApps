//
//  CategoriesPresenter.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import Foundation

final class CategoriesPresenter: CategoriesViewToPresenterProtocol {
    weak var view: CategoriesPresenterToViewProtocol?
    var router: CategoriesPresenterToRouterProtocol?
    
    func viewDidLoad() {
        view?.showCategories(NewsCategory.allCases)
    }
    
    func didSelectCategory(_ category: NewsCategory) {
        router?.navigateToSources(from: view, category: category)
    }
}
