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
    
    var currentIndex : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        /*swipeableView.didTap = {view, location in
            self.goToDetail()
        }*/
        
        swipeableView.didSwipe = {view, direction, vector in
            if direction == .Right
            {
                self.goToDetail()
            }
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        // Do any additional setup after loading the view.
    }
    
    func goToDetail()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileSelectedViewController") as! ProfileSelectedViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.nextView = {
            return self.nextCardView()
        }
    }
    
    func nextCardView() -> UIView? {
        

        let cardView = CardView(frame: swipeableView.bounds)
        
        
        let contentView = Bundle.main.loadNibNamed("CardContentView", owner: self, options: nil)?.first! as! CardView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = cardView.backgroundColor
        contentView.fillInfo(currentIndex)
        currentIndex+=1
        if currentIndex == 4
        {currentIndex = 0}
        cardView.addSubview(contentView)
        //contentView.frame = self.swipeableView.bounds
        // This is important:
        // https://github.com/zhxnlai/ZLSwipeableView/issues/9
        // Alternative:
        let metrics = ["width":cardView.bounds.width, "height": cardView.bounds.height]
        let views = ["contentView": contentView, "cardView": cardView]
        cardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView(width)]", options: .alignAllLeft, metrics: metrics, views: views))
        cardView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView(height)]", options: .alignAllLeft, metrics: metrics, views: views))
        
        
        //cardView.fillInfo(currentIndex)
        return cardView
    }
    
    @IBAction func goToInbox(_ sender: Any) {
        print("Go To Inbox")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
