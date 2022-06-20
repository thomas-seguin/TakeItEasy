//
//  ReviewTableViewCell.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-16.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
