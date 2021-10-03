//
//  TinderViewController.swift
//  Relatable
//
//  Created by Felix Izarra on 10/1/21.
//

import UIKit
import ZLSwipeableViewSwift

class TinderViewController: BaseViewController {
    
    @IBOutlet weak var swipeableView: ZLSwipeableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.nextView = {
            return self.nextCardView()
        }
    }
    
    func nextCardView() -> UIView? {
        

        let cardView = CardView(frame: swipeableView.bounds)
        
        
        let contentView = Bundle.main.loadNibNamed("CardContentView", owner: self, options: nil)?.first! as! UIView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = cardView.backgroundColor
        
        cardView.addSubview(contentView)
        //contentView.frame = self.swipeableView.bounds
        // This is important:
        // https://github.com/zhxnlai/ZLSwipeableView/issues/9
        // Alternative:
        let metrics = ["width":cardView.bounds.width, "height": cardView.bounds.height]
        let views = ["contentView": contentView, "cardView": cardView]
        cardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView(width)]", options: .alignAllLeft, metrics: metrics, views: views))
        cardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView(height)]", options: .alignAllLeft, metrics: metrics, views: views))
        
        
    
        return cardView
    }
    
    @IBAction func goToInbox(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
