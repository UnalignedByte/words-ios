//
//  RevisionCell.swift
//  Words
//
//  Created by Rafal Grodzinski on 12/03/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit

class RevisionCell: UITableViewCell
{
    @IBOutlet var titleLabel: UILabel!


    override func awakeFromNib()
    {
        super.awakeFromNib()

        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 8.0
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.blue.withAlphaComponent(0.1).cgColor]
        gradientLayer.locations = [0.2, 1.0]
        
        backgroundView = UIView()
        backgroundView?.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientLayer = backgroundView?.layer.sublayers?.first
        gradientLayer?.frame = bounds
    }

    func setup(withLanguage language: Language)
    {
        let count = WordsDataSource.sharedInstance.revisionWordsCount(forLanguage: language)
        let titleFront = NSLocalizedString("To Review", comment: "")
        let titleBack = String(format: NSLocalizedString("%d Word(s)", comment: ""), count)
        titleLabel.text = titleFront + ": " + titleBack
    }
}
