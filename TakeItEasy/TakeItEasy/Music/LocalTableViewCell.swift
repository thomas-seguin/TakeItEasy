//
//  LocalTableViewCell.swift
//  TakeItEasy
//
//  Created by Dhananjay H. Roy on 2022-06-21.
//

import UIKit

import UIKit

import UIKit

class LocalTableViewCell: UITableViewCell {
  
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songImg: UIImageView!
    @IBOutlet weak var songName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
