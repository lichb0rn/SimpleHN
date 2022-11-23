//
//  URL+Extension.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 23.11.2022.
//

import Foundation


extension URL {
    init?(from id: Int, relativeTo baseURL: String, withExtension extension: String) {
        guard let url = URL(string: baseURL)?.appending(path: String(id)).appendingPathExtension("json") else {
            return nil
        }
        self = url
    }
}
