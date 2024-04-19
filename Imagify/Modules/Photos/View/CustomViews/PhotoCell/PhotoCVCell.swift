//
//  PhotoCVCell.swift
//  Imagify
//
//  Created by Chintan Maisuriya on 17/04/24.
//

import UIKit

class PhotoCVCell: UICollectionViewCell {
    
    // MARK: -
    
    @IBOutlet weak var ivPhoto: UIImageView!
    
    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ivPhoto.image = UIImage(named: "ImagePlaceholder")
    }
}

// MARK: -

extension PhotoCVCell {
    func setImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.ivPhoto.image = image
        }
    }
}
