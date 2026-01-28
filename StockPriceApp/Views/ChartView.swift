//
//  ChartView.swift
//  StockPriceApp
//
//  Created by Heidy Naranjo on 1/28/26.
//

import UIKit

class ChartView: UIView {
    
    // MARK: - Properties
    private var pricePoints: [PricePoint] = []
    private var isPositive: Bool = true
    
    private let gradientLayer = CAGradientLayer()
    private let lineLayer = CAShapeLayer()
    private let gridLayer = CAShapeLayer()
    
    // MARK: - Colors
    private var lineColor: UIColor {
        return isPositive ? UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0) : UIColor(red: 0.91, green: 0.30, blue: 0.24, alpha: 1.0)
    }
    
    private var gradientColors: [CGColor] {
        let baseColor = lineColor
        return [
            baseColor.withAlphaComponent(0.4).cgColor,
            baseColor.withAlphaComponent(0.1).cgColor,
            baseColor.withAlphaComponent(0.0).cgColor
        ]
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        // Setup grid layer
        gridLayer.strokeColor = UIColor.systemGray4.cgColor
        gridLayer.lineWidth = 0.5
        gridLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(gridLayer)
        
        // Setup gradient layer
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
        
        // Setup line layer
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineWidth = 2.5
        lineLayer.lineCap = .round
        lineLayer.lineJoin = .round
        layer.addSublayer(lineLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawChart()
    }
    
    // MARK: - Public Methods
    func configure(with pricePoints: [PricePoint], isPositive: Bool) {
        self.pricePoints = pricePoints
        self.isPositive = isPositive
        drawChart()
    }
    
    // MARK: - Drawing
    private func drawChart() {
        guard pricePoints.count > 1 else { return }
        
        let padding: CGFloat = 16
        let chartWidth = bounds.width - (padding * 2)
        let chartHeight = bounds.height - (padding * 2)
        
        // Draw grid
        drawGrid(padding: padding, width: chartWidth, height: chartHeight)
        
        // Calculate min/max for scaling
        let prices = pricePoints.map { $0.price }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else { return }
        
        let priceRange = maxPrice - minPrice
        let adjustedRange = priceRange == 0 ? 1.0 : priceRange
        
        // Create line path
        let linePath = UIBezierPath()
        let gradientPath = UIBezierPath()
        
        for (index, point) in pricePoints.enumerated() {
            let x = padding + (CGFloat(index) / CGFloat(pricePoints.count - 1)) * chartWidth
            let normalizedPrice = (point.price - minPrice) / adjustedRange
            let y = padding + chartHeight - (CGFloat(normalizedPrice) * chartHeight)
            
            if index == 0 {
                linePath.move(to: CGPoint(x: x, y: y))
                gradientPath.move(to: CGPoint(x: x, y: padding + chartHeight))
                gradientPath.addLine(to: CGPoint(x: x, y: y))
            } else {
                // Smooth curve using quadratic bezier
                let prevPoint = pricePoints[index - 1]
                let prevX = padding + (CGFloat(index - 1) / CGFloat(pricePoints.count - 1)) * chartWidth
                let prevNormalizedPrice = (prevPoint.price - minPrice) / adjustedRange
                let prevY = padding + chartHeight - (CGFloat(prevNormalizedPrice) * chartHeight)
                
                let midX = (prevX + x) / 2
                let midY = (prevY + y) / 2
                
                if index == 1 {
                    linePath.addLine(to: CGPoint(x: midX, y: midY))
                    gradientPath.addLine(to: CGPoint(x: midX, y: midY))
                } else {
                    linePath.addQuadCurve(to: CGPoint(x: midX, y: midY), controlPoint: CGPoint(x: prevX, y: prevY))
                    gradientPath.addQuadCurve(to: CGPoint(x: midX, y: midY), controlPoint: CGPoint(x: prevX, y: prevY))
                }
                
                if index == pricePoints.count - 1 {
                    linePath.addLine(to: CGPoint(x: x, y: y))
                    gradientPath.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        
        // Close gradient path
        gradientPath.addLine(to: CGPoint(x: padding + chartWidth, y: padding + chartHeight))
        gradientPath.close()
        
        // Update line layer
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = lineColor.cgColor
        
        // Update gradient layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = gradientPath.cgPath
        gradientLayer.mask = maskLayer
        gradientLayer.colors = gradientColors
        gradientLayer.frame = bounds
        
        // Animate the line drawing
        animateChart()
    }
    
    private func drawGrid(padding: CGFloat, width: CGFloat, height: CGFloat) {
        let gridPath = UIBezierPath()
        
        // Horizontal grid lines
        let horizontalLines = 4
        for i in 0...horizontalLines {
            let y = padding + (CGFloat(i) / CGFloat(horizontalLines)) * height
            gridPath.move(to: CGPoint(x: padding, y: y))
            gridPath.addLine(to: CGPoint(x: padding + width, y: y))
        }
        
        // Vertical grid lines
        let verticalLines = 6
        for i in 0...verticalLines {
            let x = padding + (CGFloat(i) / CGFloat(verticalLines)) * width
            gridPath.move(to: CGPoint(x: x, y: padding))
            gridPath.addLine(to: CGPoint(x: x, y: padding + height))
        }
        
        gridLayer.path = gridPath.cgPath
    }
    
    private func animateChart() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        lineLayer.add(animation, forKey: "lineAnimation")
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        fadeAnimation.duration = 1.2
        gradientLayer.add(fadeAnimation, forKey: "fadeAnimation")
    }
}

