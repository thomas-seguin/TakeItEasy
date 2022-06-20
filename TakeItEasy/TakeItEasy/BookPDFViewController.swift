//
//  BookPDFViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/9/22.
//
import UIKit
//import PDFKit
import WebKit

class BookPDFViewController: UIViewController {

    @IBOutlet weak var bookTitleLabel: UILabel!
    var bookName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myView = WKWebView(frame: view.bounds)
        myView.load(URLRequest(url: URL(string: bookName!)!))
        myView.autoresizesSubviews = true
        view.addSubview(myView)

    }

}
