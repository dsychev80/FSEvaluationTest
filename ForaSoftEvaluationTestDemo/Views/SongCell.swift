//
//  SongCell.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/11/21.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var trackNumberLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!

    func configure(with song: Song) {
        trackNumberLabel.text = String(song.trackNumber)
        trackNameLabel.text = song.name
    }
    
}
