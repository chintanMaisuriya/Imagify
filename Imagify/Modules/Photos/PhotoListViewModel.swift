//
//  PhotoListViewModel.swift
//  Imagify
//
//  Created by Chintan Maisuriya on 17/04/24.
//

import Foundation

final class PhotoListViewModel {
    private let service: PhotoRetrievalService

    init(service: PhotoRetrievalService = PhotoService()) {
        self.service = service
    }
    
    // MARK: - Properties
    
    private var currentPage     : Int = 1
    private var itemsPerPage    : Int = 30
    var isPageRefreshing        : Bool = false
    var photos                  : Photos = []
    
    // MARK: -

    func loadPhotos() async throws {
        let _photos = try await service.getPhotos(forPage: currentPage, perPageItemsLimit: itemsPerPage)
        await MainActor.run {
            self.isPageRefreshing = false

            if self.currentPage > 1 {
                self.photos.append(contentsOf: _photos)
            } else {
                self.photos = _photos
            }
            
            debugPrint("API response - Photos count for Page\(self.currentPage): \(_photos.count)")
            debugPrint("Photos count for Page\(self.currentPage): \(self.photos.count)")

            self.currentPage += 1
        }
    }
    
    func photo(atIndexPath indexPath: IndexPath) -> Photo {
        photos[indexPath.item]
    }
}
