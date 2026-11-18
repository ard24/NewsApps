//
//  ArticleDetailViewController.swift
//  NewsArticlesApp
//
//  Created by MacBook on 18/11/26.
//

import UIKit
import WebKit

final class ArticleDetailViewController: UIViewController, ArticleDetailPresenterToViewProtocol, WKNavigationDelegate {
    var presenter: ArticleDetailViewToPresenterProtocol?
    
    private let webView = WKWebView()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private var progressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.addSubview(progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),
            
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            let progress = Float(webView.estimatedProgress)
            self?.progressView.progress = progress
            self?.progressView.isHidden = progress >= 1.0
        }
    }
    
    func loadURL(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Failed open articles", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showError(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showError(error.localizedDescription)
    }
}
