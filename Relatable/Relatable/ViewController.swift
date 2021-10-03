//
//  ViewController.swift
//  Relatable
//
//  Created by Felix Izarra on 10/1/21.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var ParentButton: UIButton!
    
    @IBOutlet weak var supporterButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ParentButton.setTitle("We are a beautiful family, our youngest daugther, Diana, just got diagnosed for with Leucemia. We are hopeful and sure that things will go fine but we need some help to make her undestand the situation.", for: .normal)
        
        ParentButton.backgroundColor = StaticData.colorForName(StaticData.colors[0])//6
        
        ParentButton.layer.cornerRadius = 5
        
        supporterButton.backgroundColor = StaticData.colorForName(StaticData.colors[6])//6
        
        supporterButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func parentLogin(_ sender: Any) {
        
    }
    
    @IBAction func supporterLogin(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TinderViewController") as! TinderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    


}

