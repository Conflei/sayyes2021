//
//  RecommendationsViewController.swift
//  Relatable
//
//  Created by Felix Izarra on 10/3/21.
//

import UIKit

class RecommendationsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToCamera(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
