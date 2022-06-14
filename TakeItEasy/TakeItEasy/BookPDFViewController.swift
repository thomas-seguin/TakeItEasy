//
//  BookPDFViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/9/22.
//

import UIKit
import PDFKit

class BookPDFViewController: UIViewController {

    @IBOutlet weak var bookTitleLabel: UILabel!
    var bookName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = bookName!
        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoScales = true
        let filePath = Bundle.main.url(forResource: bookName, withExtension: "pdf")
        pdfView.document = PDFDocument(url: filePath!)
        
        view.addSubview(pdfView)

    }

}
