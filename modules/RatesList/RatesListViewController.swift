//
//  RatesListViewController.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import UIKit
import SnapKit

final class RatesListViewController: UIViewController, RatesListViewProtocol {
    var presenter: RatesListPresenterProtocol!
    private var rates: [ExchangeRateItem] = []

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.register(RateDetailedCell.self, forCellReuseIdentifier: RateDetailedCell.reuseId)
        table.dataSource = self
        return table
    }()

    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        title = "Курсы валют"
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc private func refresh() {
        presenter.didPullToRefresh()
    }

    func showLoading() {
        if !refreshControl.isRefreshing { activityIndicator.startAnimating() }
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }

    func displayRates(_ rates: [ExchangeRateItem]) {
        self.rates = rates
        tableView.reloadData()
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension RatesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RateDetailedCell.reuseId,
            for: indexPath
        ) as? RateDetailedCell else {
            return UITableViewCell()
        }
        let item = rates[indexPath.row]
        cell.configure(with: item)
        cell.onFavoriteTap = { [weak self] in
            self?.presenter.didToggleFavorite(for: item.code)
        }
        return cell
    }
}

extension RatesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.didSearch(query: searchController.searchBar.text ?? "")
    }
}
