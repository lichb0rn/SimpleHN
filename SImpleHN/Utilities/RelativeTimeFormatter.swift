//
//  RelativeTimeFormatter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation

struct RelativeTimeFormatter {
    private static var relativeFormatter = RelativeDateTimeFormatter()
    
    static func formatTimeString(timeInterval interval: TimeInterval) -> String {
        let currentDate = Date()
        
        let relativeTimeString = relativeTime(fromInterval: interval, relativeTo: currentDate)
        let formattedString = "Posted " + relativeTimeString
        
        return formattedString
    }
    
    
    static func relativeTime(fromInterval timeInterval: TimeInterval, relativeTo date: Date) -> String {
        RelativeTimeFormatter
            .relativeFormatter
            .localizedString(
                fromTimeInterval: timeInterval - date.timeIntervalSince1970
            )
    }
}
