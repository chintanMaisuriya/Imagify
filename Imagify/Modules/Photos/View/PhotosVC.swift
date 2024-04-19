//
//  PhotosVC.swift
//  Imagify
//
//  Created by Chintan Maisuriya on 17/04/24.
//

import UIKit

class PhotosVC: UIViewController {
    
    // MARK: -
    
    private let viewModel = PhotoListViewModel()
    
    // MARK: -
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.invalidateLayout()
    }
}


// MARK: -

extension PhotosVC {
    private func getPhotos() {
        Task {
            do {
                try await viewModel.loadPhotos()
                reloadCollectionView()
            } catch {
                debugPrint(error)
            }
        }
    }
    
    private func getMorePhotos() {
        guard !viewModel.isPageRefreshing else { return }
        viewModel.isPageRefreshing = true
        reloadCollectionView()

        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(3)) {
            self.getPhotos()
        }
    }
    
    private func downloadImage(imageURL: String?, indexPath: IndexPath) {
        ImageDownloadManager.shared.downloadImage(imageURL, indexPath: indexPath) { [weak self] (image, url, indexPathh, error) in
            guard let self else { return }
            DispatchQueue.main.async {
                guard let indexPathNew = indexPathh, let cell = self.collectionView.cellForItem(at: indexPathNew) as? PhotoCVCell else { return }
                cell.setImage(image)
            }
        }
    }
}


// MARK: -

extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == viewModel.photos.count - 6) {
            getMorePhotos()
        }
        
        guard (!viewModel.photos.isEmpty && viewModel.photos.indices.contains(indexPath.item)) else { return }
        let photo = viewModel.photo(atIndexPath: indexPath)
        downloadImage(imageURL: photo.urls?.thumb, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard (!viewModel.photos.isEmpty && viewModel.photos.indices.contains(indexPath.item)) else { return }
        let photo = viewModel.photo(atIndexPath: indexPath)
        ImageDownloadManager.shared.slowDownImageDownloadTaskfor(photo.urls?.thumb)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCVCell", for: indexPath) as? PhotoCVCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            guard (indexPath.section == 0) else { return UICollectionReusableView() }
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoaderFooterView.identifier,for: indexPath) as? LoaderFooterView else { return UICollectionReusableView() }
            return view
            
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == UICollectionView.elementKindSectionFooter else { return }
        guard let view = view as? LoaderFooterView else { return }
        view.activityIndicator.startAnimating()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == UICollectionView.elementKindSectionFooter else { return }
        guard let view = view as? LoaderFooterView else { return }
        view.activityIndicator.stopAnimating()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isLandscapeOrientation = UIDevice.current.orientation.isLandscape
        let spacing: CGFloat = 2
        let itemsPerRow: CGFloat = UIDevice.isPad ? (isLandscapeOrientation ? 5 : 4) : (isLandscapeOrientation ? 4 : 3)
        let frameWH = ((collectionView.frame.size.width - ((itemsPerRow - 1) * spacing)) / itemsPerRow)
        return CGSize(width: frameWH, height: frameWH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard (section == 0) else { return .zero }
        return viewModel.isPageRefreshing ? CGSize(width: collectionView.frame.width, height: 44) : .zero
    }
}

// MARK: -

extension PhotosVC {
    private func initialConfiguration() {
        configureCollectionView()
        getMorePhotos()
    }
    
    func configureCollectionView() {
        collectionView.register(LoaderFooterView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoaderFooterView.identifier)
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates {
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
}
