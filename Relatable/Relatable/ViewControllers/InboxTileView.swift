//
//  InboxTileView.swift
//  Relatable
//
//  Created by Felix Izarra on 10/2/21.
//

import UIKit
import UIColor_FlatColors

class InboxTileView: UIView {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var personName: UILabel!
    
    @IBOutlet weak var numberMess: UIView!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    
    var pfpNames: [String] = ["kidp1","kidp2","kidp3","kidp4","support1","support2","support3"]
    
    
    let nibName = "InboxTileView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        containerView = view
        
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func fillInfo(_ name: String, _ pIndex: Int, _ showNum: Bool = false)
    {
        profilePic.image = UIImage(named: pfpNames[pIndex])
        profilePic.layer.cornerRadius = 35
        personName.text = name
        numberMess.isHidden = !showNum
        numberMess.layer.cornerRadius = 18
        bgView.layer.cornerRadius = 10
        if StaticData.parent
        {
            bgView.backgroundColor = StaticData.colorForName(StaticData.colors[0])
        }else
        {
            bgView.backgroundColor = StaticData.colorForName(StaticData.colors[6])
        }
        
        
        
    }

}
