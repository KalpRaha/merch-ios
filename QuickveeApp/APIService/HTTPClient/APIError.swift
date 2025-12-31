//
//  APIError.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 30/12/25.
//

import Foundation

enum APIError : Error {
    case invalidURL
    case invalidServerResponse
    case errorFromServer(statusCode : Int, data : Data)
    case errorWhileDecoding(Error)
}
