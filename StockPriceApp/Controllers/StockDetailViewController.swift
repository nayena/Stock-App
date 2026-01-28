//
//  StockDetailViewController.swift
//  StockPriceApp
//
//  Created by Heidy Naranjo on 1/28/26.
//

import UIKit

class StockDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let stock: Stock
    
    // MARK: - Colors
    private let positiveColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
    private let negativeColor = UIColor(red: 0.91, green: 0.30, blue: 0.24, alpha: 1.0)
    
    private var accentColor: UIColor {
        return stock.isPositiveChange ? positiveColor : negativeColor
    }
    
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
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let changeContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let chartContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Performance"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chartView: ChartView = {
        let chart = ChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    private let statsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Stats"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    init(stock: Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithStock()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backButton)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(changeContainerView)
        changeContainerView.addSubview(arrowImageView)
        changeContainerView.addSubview(changeLabel)
        
        contentView.addSubview(chartContainerView)
        chartContainerView.addSubview(chartTitleLabel)
        chartContainerView.addSubview(chartView)
        
        contentView.addSubview(statsContainerView)
        statsContainerView.addSubview(statsTitleLabel)
        statsContainerView.addSubview(statsStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            symbolLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            changeContainerView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            changeContainerView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 12),
            changeContainerView.heightAnchor.constraint(equalToConstant: 32),
            
            arrowImageView.leadingAnchor.constraint(equalTo: changeContainerView.leadingAnchor, constant: 10),
            arrowImageView.centerYAnchor.constraint(equalTo: changeContainerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 14),
            arrowImageView.heightAnchor.constraint(equalToConstant: 14),
            
            changeLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 4),
            changeLabel.trailingAnchor.constraint(equalTo: changeContainerView.trailingAnchor, constant: -10),
            changeLabel.centerYAnchor.constraint(equalTo: changeContainerView.centerYAnchor),
            
            chartContainerView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 32),
            chartContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            chartContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            chartTitleLabel.topAnchor.constraint(equalTo: chartContainerView.topAnchor, constant: 20),
            chartTitleLabel.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: 20),
            
            chartView.topAnchor.constraint(equalTo: chartTitleLabel.bottomAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: 8),
            chartView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor, constant: -8),
            chartView.heightAnchor.constraint(equalToConstant: 200),
            chartView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -20),
            
            statsContainerView.topAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: 20),
            statsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            statsTitleLabel.topAnchor.constraint(equalTo: statsContainerView.topAnchor, constant: 20),
            statsTitleLabel.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor, constant: 20),
            
            statsStackView.topAnchor.constraint(equalTo: statsTitleLabel.bottomAnchor, constant: 16),
            statsStackView.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor, constant: -20),
            statsStackView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor, constant: -20),
        ])
    }
    
    private func configureWithStock() {
        symbolLabel.text = stock.symbol
        nameLabel.text = stock.name
        priceLabel.text = String(format: "$%.2f", stock.currentPrice)
        
        let changeText = String(format: "%@%.2f (%.2f%%)",
                                stock.isPositiveChange ? "+" : "",
                                stock.priceChange,
                                stock.priceChangePercent)
        changeLabel.text = changeText
        changeLabel.textColor = accentColor
        changeContainerView.backgroundColor = accentColor.withAlphaComponent(0.2)
        
        let arrowName = stock.isPositiveChange ? "arrow.up.right" : "arrow.down.right"
        arrowImageView.image = UIImage(systemName: arrowName)
        arrowImageView.tintColor = accentColor
        
        chartView.configure(with: stock.priceHistory, isPositive: stock.isPositiveChange)
        
        // Setup stats
        let stats: [(String, String, UIImage?)] = [
            ("Opening Price", String(format: "$%.2f", stock.openPrice), UIImage(systemName: "sunrise.fill")),
            ("Previous Close", String(format: "$%.2f", stock.previousClose), UIImage(systemName: "clock.fill")),
            ("Daily High", String(format: "$%.2f", stock.dailyHigh), UIImage(systemName: "arrow.up.circle.fill")),
            ("Daily Low", String(format: "$%.2f", stock.dailyLow), UIImage(systemName: "arrow.down.circle.fill"))
        ]
        
        for (index, stat) in stats.enumerated() {
            let statRow = createStatRow(title: stat.0, value: stat.1, icon: stat.2, index: index)
            statsStackView.addArrangedSubview(statRow)
        }
    }
    
    private func createStatRow(title: String, value: String, icon: UIImage?, index: Int) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = accentColor.withAlphaComponent(0.15)
        iconContainer.layer.cornerRadius = 10
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView(image: icon)
        iconView.tintColor = accentColor
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = UIColor.systemGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 44),
            
            iconContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 36),
            iconContainer.heightAnchor.constraint(equalToConstant: 36),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        
        // Add subtle animation for each row
        container.alpha = 0
        container.transform = CGAffineTransform(translationX: 0, y: 10)
        
        UIView.animate(withDuration: 0.4, delay: Double(index) * 0.1, options: .curveEaseOut) {
            container.alpha = 1
            container.transform = .identity
        }
        
        return container
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}

