//
//  SenderTableViewCell.swift
//  Relatable
//
//  Created by Felix Izarra on 10/2/21.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    var url: String = ""
    var parentView: ChatViewController?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAction(_ sender: Any) {
        print(#function)
        parentView?.playVideo(url)
    }
    
}
