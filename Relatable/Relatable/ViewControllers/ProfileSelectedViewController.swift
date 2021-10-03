//
//  ProfileSelectedViewController.swift
//  Relatable
//
//  Created by Felix Izarra on 10/2/21.
//

import UIKit

class ProfileSelectedViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 390, height: 800)
        
        //let view = UIView()
        //view.backgroundColor = .white
       
       // Create UIButton
        let myButton = UIButton(type: .system)
       
       // Position Button
        myButton.frame = CGRect(x: view.frame.width/2.0 - 130, y: view.frame.height - 100, width: 260, height: 50)
       // Set text on button
        myButton.setTitle("Record Message for Diana", for: .normal)
        myButton.backgroundColor = StaticData.colorForName(StaticData.colors[6])
       
       // Set button action
        myButton.addTarget(self, action: #selector(goToRecord), for: .touchUpInside)
        
        myButton.layer.cornerRadius = 20
        myButton.layer.shadowRadius = 3
        myButton.layer.shadowOpacity = 0.6
        myButton.tintColor = .white
        myButton.titleLabel?.font = UIFont(name: "GothamSSm-Bold", size: 14)
        
       
       view.addSubview(myButton)
       //self.view = view
        //self.view = view
        
    }
    
    @objc func goToRecord()
    {
        print("GoToRecord")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecommendationsViewController") as! RecommendationsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class BaseButton: UIButton {
    var action: (() -> Void)?

    func whenButtonIsClicked(action: @escaping () -> Void) {
        self.action = action
        self.addTarget(self, action: #selector(BaseButton.clicked), for: .touchUpInside)
    }

    @objc func clicked() {
        action?()
    }
}
