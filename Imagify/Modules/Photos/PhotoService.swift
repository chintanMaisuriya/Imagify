//
//  PhotoService.swift
//  Imagify
//
//  Created by Chintan Maisuriya on 17/04/24.
//

import Foundation

// MARK: - PostRequest

enum PhotoRequest: Request {
    case getPhotos(pageIndex: Int, perPageItemsLimit: Int)
    case getPhoto(id: Int)
    
    var path: String {
        switch self {
        case .getPhotos:
            return "/photos"
        case .getPhoto(let id):
            return "/photos/\(id)"
        }
    }
    
    var queryItems: [String : String] {
        var urlQueryParams: [String : String] = ["client_id": AppKeyConstants.shared.unsplashClientId]
        
        switch self {
        case .getPhotos(let pageIndex, let perPageItemsLimit):
            urlQueryParams["page"] = "\(pageIndex)"
            urlQueryParams["per_page"] = "\(perPageItemsLimit)"
            urlQueryParams["order_by"] = ""
        default: break
        }
        
        return urlQueryParams
    }
}

protocol PhotoRetrievalService {
    func getPhotos(forPage page: Int, perPageItemsLimit limit: Int) async throws -> [Photo]
    func getPhotoById(_ id: Int) async throws -> Photo?
}

// MARK: - PostService

class PhotoService: PhotoRetrievalService {
    let networkManager: NetworkHandler
    
    init(networkManager: NetworkHandler = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getPhotos(forPage page: Int, perPageItemsLimit limit: Int) async throws -> [Photo] {
        try await networkManager.fetch(request: PhotoRequest.getPhotos(pageIndex: page, perPageItemsLimit: limit))
    }
    
    func getPhotoById(_ id: Int) async throws -> Photo? {
        try await networkManager.fetch(request: PhotoRequest.getPhoto(id: id))
    }
}
