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
    
    var books = ["bookSample"]
    var filteredBooks = [String]()
    var isSearchingBook = false
    
    var allBooks = [Books]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBooks(){/*data in*/
            //self.allBooks = data
            DispatchQueue.main.async {
                self.generalBooksCollection.reloadData()
                self.technicalBooksCollection.reloadData()
                self.cookBooksCollection.reloadData()
            }
        }

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
        let bookPDFController = storyObject.instantiateViewController(withIdentifier: "bookPDF") as! BookPDFViewController
        if collectionView == generalBooksCollection{
            bookPDFController.bookName = "bookSample"
        }else if (collectionView == technicalBooksCollection) {
            bookPDFController.bookName = "bookSample"
        } else{
            bookPDFController.bookName = "bookSample"

        }

                navigationController?.pushViewController(bookPDFController, animated: true)
    }
    
    func fetchBooks(completion: @escaping (/*[Books]*/) -> ()){
        
        let session = URLSession.shared
        
        let urlString = "https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json?api-key=jHTLUbJD4QhdeZmiMbeFb0MEVYxI8H1E"
        let fetchURL = URL(string: urlString)
        guard fetchURL != nil else{
            print("Error ---> fetching Books Url")
            return
        }
        let bufferedData = session.dataTask(with: fetchURL!){data, response, error in
            if data != nil, error == nil {
                let decoder = JSONDecoder()
                do{
                    let decodedBooks = try decoder.decode(BooksApi.self, from: data!)
                    print(decodedBooks) //trials remove
                    completion(/*decodedBooks*/)
                }catch{
                    print("Error ---> Decoding books")
                }
            }
        }
        bufferedData.resume()
        
    }

}

extension BooksViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBooks = books.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearchingBook = true
        self.generalBooksCollection.reloadData()
    }
    
}
struct BooksApi: Decodable {
    var status: String
    var copyright: String
    var results: Int
    //var results: [String]
}
struct Books: Decodable{
    var author: String?
    var title: String?
    //var book_image: String?
}
