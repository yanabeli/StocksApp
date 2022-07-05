//
//  Extensions.swift
//  StocksApp
//
//  Created by Yana Beliakova on 02.07.22.
//

import Foundation
import UIKit

// MARK: - Notification

extension Notification.Name {
    /// Notification for when symbol gets added to watchlist
    static let didAddToWatchList = Notification.Name("didAddToWatchList")
    
}

// NumberFormatter

extension NumberFormatter {
    /// Formatter for percent style
    static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    ///  Formatter for decimal style
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

// ImageView

extension UIImageView {
    /// Sets image from remote url
    /// - Parameter url: URL to fetch from
    func setImage(with url: URL?) {
        guard let url = url else {
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}

// MARK: - String

extension String {
    ///  Create String from time interval
    ///  - Parameter timeInterval: TimeInterval since 1970
    ///  - Returns: Formatted string
    static func string(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.prettyDateFormatter.string(from: date)
    }
    
    ///  Percentage formatted string
    ///  - Parameter double: Double to format
    ///  - Returns: String in percent format
    static func percentage(from double: Double) -> String {
        let formatter = NumberFormatter.percentFormatter
        return formatter.string(from: NSNumber(value: double)) ?? "\(double)"
    }
    
    ///  Format number to string
    ///  - Parameter number: Number to form
    ///  - Returns: Formatted string
    static func formatted(number: Double) -> String {
        let formatter = NumberFormatter.numberFormatter
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

// MARK: - DateFormatter

extension DateFormatter {
    static let newsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    static let prettyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}

// MARK: - Add Subview

extension UIView {
    /// Adds multiple subviews
    /// - Parameter views: Collection of subviews
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

// MARK: - Framing

extension UIView {
    /// Width or view
    var width: CGFloat {
        frame.size.width
    }
    
    /// Height or view
    var height: CGFloat {
        frame.size.height
    }
    
    /// Left edge of view
    var left: CGFloat {
        frame.origin.x
    }
    
    /// Right edge of view
    var right: CGFloat {
        left + width
    }
    
    /// Top edge of view
    var top: CGFloat {
        frame.origin.y
    }
    
    /// Bottom edge of view
    var bottom: CGFloat {
        top + height
    }
}

// MARK: - CandleStick Sorting

extension Array where Element == CandleStick {
    func getPercentage() -> Double {
            let latestDate = self[0].date
            guard let latestClose = self.first?.close,
                let priorClose = self.first(where: {
                    !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
                })?.close else {
                    return 0
                }
            
            let diff = 1 - (priorClose/latestClose)
            return diff
        
    }
}
