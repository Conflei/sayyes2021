//
//  CardView.swift
//  Relatable
//
//  Created by Felix Izarra on 10/1/21.
//

import UIKit

class CardView: UIView {
    
    @IBOutlet weak var bgPic: UIImageView!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var title: UILabel!
    
    let nibName = "CardContentView"
    
    var images: [String] = ["ivon","walter","dianaa", "felixi"]
    var names: [String]  = ["Ivon","Walter Jr.", "Diana", "Felix"]
    var descriptions: [String] = ["Recently had an eye infection","Walter Jr. has cerebral palsy", "Recently diagnosed with Leukaemia", "He broke his arm and is now wearing a cast"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(_ pIndex: Int = 0) {
        
        
        //
        //
        //
        
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
    
    func fillInfo(_ pIndex: Int)
    {
        self.title.text = names[pIndex]
        self.descr.text = descriptions[pIndex]
        self.bgPic.image = UIImage(named: images[pIndex])
    }
}

