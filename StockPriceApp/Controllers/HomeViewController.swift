//
//  HomeViewController.swift
//  StockPriceApp
//
//  Created by Heidy Naranjo on 1/28/26.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let stocks = Stock.sampleStocks
    
    // MARK: - UI Elements
    private let backgroundGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.08, alpha: 1.0).cgColor,
            UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1.0).cgColor
        ]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stocks"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Overview"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        label.text = formatter.string(from: Date())
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.register(StockCell.self, forCellReuseIdentifier: StockCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let marketStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 0.15)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let marketStatusDot: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let marketStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Open"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startMarketStatusAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
        
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(marketStatusView)
        marketStatusView.addSubview(marketStatusDot)
        marketStatusView.addSubview(marketStatusLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            
            marketStatusView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            marketStatusView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            marketStatusView.heightAnchor.constraint(equalToConstant: 28),
            
            marketStatusDot.leadingAnchor.constraint(equalTo: marketStatusView.leadingAnchor, constant: 10),
            marketStatusDot.centerYAnchor.constraint(equalTo: marketStatusView.centerYAnchor),
            marketStatusDot.widthAnchor.constraint(equalToConstant: 8),
            marketStatusDot.heightAnchor.constraint(equalToConstant: 8),
            
            marketStatusLabel.leadingAnchor.constraint(equalTo: marketStatusDot.trailingAnchor, constant: 6),
            marketStatusLabel.trailingAnchor.constraint(equalTo: marketStatusView.trailingAnchor, constant: -10),
            marketStatusLabel.centerYAnchor.constraint(equalTo: marketStatusView.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func startMarketStatusAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse]) {
            self.marketStatusDot.alpha = 0.3
        }
    }
}

// MARK: - UITableViewDelegate & DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else {
            return UITableViewCell()
        }
        cell.configure(with: stocks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stock = stocks[indexPath.row]
        let detailVC = StockDetailViewController(stock: stock)
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true)
    }
}

