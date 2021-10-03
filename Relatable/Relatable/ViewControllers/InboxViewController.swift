//
//  InboxViewController.swift
//  Relatable
//
//  Created by Felix Izarra on 10/2/21.
//

import UIKit

class InboxViewController: BaseViewController {
    
    @IBOutlet weak var firstTile: InboxTileView!
    @IBOutlet weak var secondTile: InboxTileView!
    @IBOutlet weak var thirdTile: InboxTileView!
    @IBOutlet weak var forthTile: InboxTileView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if StaticData.parent
        {
            firstTile.fillInfo("Brenda", 5, true)
            secondTile.fillInfo("Pipo", 6)
            thirdTile.fillInfo("Mariana", 4)
            forthTile.isHidden = true
            
        }
        else
        {
            firstTile.fillInfo("Diana", 2)
            secondTile.fillInfo("Dave", 3)
            thirdTile.fillInfo("Clara", 1)
            forthTile.fillInfo("JM", 0)
            
        }
        
        //let gest = UIGestureRecognizer(target: <#T##Any?#>, action: <#T##Selector?#>)
    }
    

   

}
