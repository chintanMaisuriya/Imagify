//
//  APIHost.swift
//  Imagify
//
//  Created by Chintan Maisuriya on 15/04/24.
//

import Foundation

// MARK: -

enum APIHost {
    case base
    
    var urlString: String {
        switch self {
        case .base  : return "api.unsplash.com"
        }
    }
}
