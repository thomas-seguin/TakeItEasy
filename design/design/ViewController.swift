//
//  ViewController.swift
//  design
//
//  Created by admin on 6/16/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    @objc private func didTapButton(){
        let vc = SecondViewController()
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }

}

