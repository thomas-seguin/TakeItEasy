//
//  SearchViewController.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-08.
//

import UIKit

class SearchViewController: UIViewController {
    
    let mySearchView = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = mySearchView.displayGoogle()
    }
    

}
