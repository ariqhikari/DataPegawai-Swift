//
//  TableViewCell.swift
//  DataPegawai
//
//  Created by Ariq Hikari on 10/06/23.
//

import UIKit

class TableViewCell: UITableViewCell {

  @IBOutlet weak var titleCell: UILabel!
  @IBOutlet weak var subtitleCell: UILabel!
  @IBOutlet weak var imageCell: UIImageView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
