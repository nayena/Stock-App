//
//  StockCell.swift
//  StockPriceApp
//
//  Created by Heidy Naranjo on 1/28/26.
//

import UIKit

class StockCell: UITableViewCell {
    
    static let identifier = "StockCell"
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let changeContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let miniChartView: ChartView = {
        let chart = ChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Colors
    private let positiveColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
    private let negativeColor = UIColor(red: 0.91, green: 0.30, blue: 0.24, alpha: 1.0)
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(symbolLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(miniChartView)
        containerView.addSubview(priceLabel)
        containerView.addSubview(changeContainerView)
        changeContainerView.addSubview(changeLabel)
        changeContainerView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            symbolLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            symbolLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120),
            
            miniChartView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            miniChartView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            miniChartView.widthAnchor.constraint(equalToConstant: 80),
            miniChartView.heightAnchor.constraint(equalToConstant: 40),
            
            priceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            changeContainerView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 6),
            changeContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            changeContainerView.heightAnchor.constraint(equalToConstant: 28),
            
            arrowImageView.leadingAnchor.constraint(equalTo: changeContainerView.leadingAnchor, constant: 8),
            arrowImageView.centerYAnchor.constraint(equalTo: changeContainerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 12),
            
            changeLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 4),
            changeLabel.trailingAnchor.constraint(equalTo: changeContainerView.trailingAnchor, constant: -10),
            changeLabel.centerYAnchor.constraint(equalTo: changeContainerView.centerYAnchor),
        ])
    }
    
    // MARK: - Configuration
    func configure(with stock: Stock) {
        symbolLabel.text = stock.symbol
        nameLabel.text = stock.name
        priceLabel.text = String(format: "$%.2f", stock.currentPrice)
        
        let changeText = String(format: "%@%.2f (%.2f%%)",
                                stock.isPositiveChange ? "+" : "",
                                stock.priceChange,
                                stock.priceChangePercent)
        changeLabel.text = changeText
        
        let color = stock.isPositiveChange ? positiveColor : negativeColor
        changeContainerView.backgroundColor = color.withAlphaComponent(0.2)
        changeLabel.textColor = color
        
        let arrowName = stock.isPositiveChange ? "arrow.up.right" : "arrow.down.right"
        arrowImageView.image = UIImage(systemName: arrowName)
        arrowImageView.tintColor = color
        
        miniChartView.configure(with: stock.priceHistory, isPositive: stock.isPositiveChange)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.1) {
            self.containerView.transform = highlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            self.containerView.alpha = highlighted ? 0.8 : 1.0
        }
    }
}

