//
//  CardView.swift
//  Relatable
//
//  Created by Felix Izarra on 10/1/21.
//

import UIKit

class CardView: UIView {
    
    @IBOutlet weak var bgPic: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descr: UILabel!
    
    let nibName = "CardContentView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        
        
        //self.bgPic.image = sdad
        
        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        // Corner Radius
        layer.cornerRadius = 10.0;
    }
    
    func fillInfo(_ bgName: String = "", _ title: String = "", _ descr: String = "")
    {
        self.title.text = title
        self.descr.text = descr
    }
}

