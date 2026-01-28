//
//  Stock.swift
//  StockPriceApp
//
//  Created by Heidy Naranjo on 1/28/26.
//

import Foundation

struct Stock {
    let symbol: String
    let name: String
    let currentPrice: Double
    let previousClose: Double
    let openPrice: Double
    let dailyHigh: Double
    let dailyLow: Double
    let priceHistory: [PricePoint]
    
    var priceChange: Double {
        return currentPrice - previousClose
    }
    
    var priceChangePercent: Double {
        return (priceChange / previousClose) * 100
    }
    
    var isPositiveChange: Bool {
        return priceChange >= 0
    }
}

struct PricePoint {
    let time: Date
    let price: Double
}

// MARK: - Sample Data Extension
extension Stock {
    static let sampleStocks: [Stock] = [
        Stock(
            symbol: "AAPL",
            name: "Apple Inc.",
            currentPrice: 178.72,
            previousClose: 175.10,
            openPrice: 175.50,
            dailyHigh: 180.25,
            dailyLow: 174.80,
            priceHistory: Stock.generatePriceHistory(base: 175.50, current: 178.72)
        ),
        Stock(
            symbol: "AMZN",
            name: "Amazon.com Inc.",
            currentPrice: 178.25,
            previousClose: 180.75,
            openPrice: 180.00,
            dailyHigh: 181.50,
            dailyLow: 177.25,
            priceHistory: Stock.generatePriceHistory(base: 180.00, current: 178.25)
        ),
        Stock(
            symbol: "GOOGL",
            name: "Alphabet Inc.",
            currentPrice: 141.80,
            previousClose: 139.50,
            openPrice: 140.00,
            dailyHigh: 143.25,
            dailyLow: 139.10,
            priceHistory: Stock.generatePriceHistory(base: 140.00, current: 141.80)
        ),
        Stock(
            symbol: "META",
            name: "Meta Platforms Inc.",
            currentPrice: 505.45,
            previousClose: 510.20,
            openPrice: 508.00,
            dailyHigh: 512.75,
            dailyLow: 502.30,
            priceHistory: Stock.generatePriceHistory(base: 508.00, current: 505.45)
        ),
        Stock(
            symbol: "MSFT",
            name: "Microsoft Corp.",
            currentPrice: 415.50,
            previousClose: 408.25,
            openPrice: 410.00,
            dailyHigh: 418.90,
            dailyLow: 407.50,
            priceHistory: Stock.generatePriceHistory(base: 410.00, current: 415.50)
        )
    ]
    
    private static func generatePriceHistory(base: Double, current: Double) -> [PricePoint] {
        var history: [PricePoint] = []
        let calendar = Calendar.current
        let now = Date()
        
        // Generate hourly price points for the trading day (9:30 AM to 4:00 PM)
        let startHour = 9
        let startMinute = 30
        let totalMinutes = 390 // 6.5 hours of trading
        let intervals = 26 // ~15 minute intervals
        
        for i in 0..<intervals {
            let minutesFromStart = (totalMinutes / intervals) * i
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = startHour + (startMinute + minutesFromStart) / 60
            components.minute = (startMinute + minutesFromStart) % 60
            
            if let time = calendar.date(from: components) {
                // Create a price that fluctuates between base and current
                let progress = Double(i) / Double(intervals - 1)
                let trend = base + (current - base) * progress
                let noise = Double.random(in: -2.0...2.0)
                let price = max(trend + noise, base * 0.95)
                
                history.append(PricePoint(time: time, price: price))
            }
        }
        
        // Ensure last point matches current price
        if var lastPoint = history.last {
            history[history.count - 1] = PricePoint(time: lastPoint.time, price: current)
        }
        
        return history
    }
}

