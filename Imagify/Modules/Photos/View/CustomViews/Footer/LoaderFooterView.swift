//
//  LoaderFooterView.swift
//  Imagify
//
//  Created by Chintan Maisuriya on 17/04/24.
//

import UIKit

class LoaderFooterView: UICollectionReusableView {

    // MARK: -
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: -

    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
