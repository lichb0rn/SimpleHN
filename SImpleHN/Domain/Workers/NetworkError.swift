//
//  NetworkError.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 23.11.2022.
//

import Foundation


enum NetworkError: Error {
    case badServerResponse
    case badRequest(Story.ID)
}
