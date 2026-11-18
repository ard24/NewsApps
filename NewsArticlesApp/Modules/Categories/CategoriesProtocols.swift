//
//  CategoriesProtocols.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import UIKit

protocol CategoriesViewToPresenterProtocol: AnyObject {
    var view: CategoriesPresenterToViewProtocol? { get set }
    var router: CategoriesPresenterToRouterProtocol? { get set }
    func viewDidLoad()
    func didSelectCategory(_ category: NewsCategory)
}

protocol CategoriesPresenterToViewProtocol: AnyObject {
    func showCategories(_ categories: [NewsCategory])
}

protocol CategoriesPresenterToRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToSources(from view: CategoriesPresenterToViewProtocol?, category: NewsCategory)
}
