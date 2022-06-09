//
//  BooksViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/8/22.
//

import UIKit

class BooksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var generalBooksCollection: UICollectionView!
    @IBOutlet weak var technicalBooksCollection: UICollectionView!
    @IBOutlet weak var cookBooksCollection: UICollectionView!
    
    var books = ["book2"]
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == generalBooksCollection {
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "generalBookCell", for: indexPath) as! GeneralBooksCollectionViewCell
            bookCell.backgroundColor = UIColor.yellow
            return bookCell
        }
        else if collectionView == technicalBooksCollection {
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "technicalBookCell", for: indexPath) as! TechnicalBooksCollectionViewCell
            bookCell.backgroundColor = UIColor.yellow
            return bookCell
        }
        else{
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cookBookCell", for: indexPath) as! CookBooksCollectionViewCell
            bookCell.backgroundColor = UIColor.yellow
            return bookCell

        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyObject = UIStoryboard(name: "Main", bundle: nil)
        let bookPDFController = storyObject.instantiateViewController(withIdentifier: "bookPdf") as! BookPDFViewController
        bookPDFController.bookName = books[0]
        navigationController?.pushViewController(bookPDFController, animated: true)
    }

}
