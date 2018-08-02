//
//  CollectionViewCell.swift
//  SavePhotoToAlbum
//
//  Created by ys on 2018. 8. 2..
//  Copyright © 2018년 ys. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var count: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
