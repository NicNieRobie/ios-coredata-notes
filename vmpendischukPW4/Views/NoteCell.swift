//
//  NoteCell.swift
//  vmpendischukPW4
//
//  Created by Vladislav on 21.10.2021.
//

import UIKit

// View used as a cell in the notes collection view.
class NoteCell: UICollectionViewCell {
    // Label used to display the note's title.
    @IBOutlet weak var titleLabel: UILabel!
    // Label used to display the note's description.
    @IBOutlet weak var descriptionLabel: UILabel!
    // Label used to display the note's creation date.
    @IBOutlet weak var dateLabel: UILabel!
    
    // Returns the optimal size of the view.
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        return size
    }
}
