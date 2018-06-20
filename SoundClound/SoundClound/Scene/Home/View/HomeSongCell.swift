//
//  HomeSongCell.swift
//  SoundClound
//
//  Created by Hai on 6/20/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import UIKit
import Reusable

final class HomeSongCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func setContentForCollectionViewCell(name: String, description: String){
        self.nameLabel.text = name
        self.descriptionLabel.text = description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
