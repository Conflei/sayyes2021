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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))

            // Add Tap Gesture Recognizer
            firstTile.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTapImageView(_ sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
