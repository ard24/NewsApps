//
//  CategoriesViewController.swift
//  NewsArticlesApp
//
//  Created by MacBook on 17/11/26.
//

import UIKit

final class CategoriesViewController: UIViewController, CategoriesPresenterToViewProtocol {
    var presenter: CategoriesViewToPresenterProtocol?
    private var categories: [NewsCategory] = []
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News Category"
        view.backgroundColor = .systemGroupedBackground
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
    }
    
    func showCategories(_ categories: [NewsCategory]) {
        self.categories = categories
        tableView.reloadData()
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = categories[indexPath.row].displayName
        config.textProperties.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectCategory(categories[indexPath.row])
    }
}
