//
//  AlbumCellTableViewCell.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/7/21.
//

import UIKit

protocol AlbumData {
    var albumName: String { get }
    var artistName: String { get }
    var releaseDate: Date { get }
    var imageData: Data? { get }
}

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    private var imageData: Data? {
        willSet {
            guard let data = newValue, !data.isEmpty else {
                self.albumImageView.image = UIImage(named: "photo")
                return
            }
            self.albumImageView.image =  UIImage(data: data)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView?.image = nil
    }
    
    func configureCellWith(data: AlbumData) {
        imageData = data.imageData
        self.nameLabel.text = data.albumName
        self.releaseDateLabel.text = data.releaseDate.formate()
    }
}

