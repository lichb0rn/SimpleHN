//
//  String+Extension.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 01.01.2023.
//

import Foundation

extension String {
    func htmlStrip() -> String {
        let data = Data(self.utf8)
        if let nsAttrString = try? NSAttributedString(data: data,
                                                      options: [.documentType: NSAttributedString.DocumentType.html],
                                                      documentAttributes: nil) {
            return nsAttrString.string
        } else {
            return self
        }
    }
}
