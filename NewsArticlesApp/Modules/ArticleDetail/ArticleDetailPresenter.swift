//
//  ArticleDetailPresenter.swift
//  NewsArticlesApp
//
//  Created by MacBook on 18/11/26.
//

import Foundation

final class ArticleDetailPresenter: ArticleDetailViewToPresenterProtocol {
    weak var view: ArticleDetailPresenterToViewProtocol?
    private let article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    func viewDidLoad() {
        guard let url = URL(string: article.url), url.scheme == "http" || url.scheme == "https" else {
            view?.showError("Articles not found or not valid")
            return
        }
        view?.loadURL(url)
    }
}
