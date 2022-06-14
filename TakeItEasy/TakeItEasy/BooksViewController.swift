//
//  BooksViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/8/22.
//

import UIKit


class BooksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var searchBooksCollection: UICollectionView!
    @IBOutlet weak var generalBooksCollection: UICollectionView!
    @IBOutlet weak var technicalBooksCollection: UICollectionView!
    @IBOutlet weak var cookBooksCollection: UICollectionView!
    
    var books = ["bookSample"]
    var filteredBooks = [String]()
    var isSearchingBook = false
    var cookBooks = [Books]()
    var generalBooks, technicalBooks: [Books]?
    
    var allBooks = [Books]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBooks(){data in
            //print(data)
            DispatchQueue.main.async {
                self.generalBooksCollection.reloadData()
                self.technicalBooksCollection.reloadData()
                self.cookBooksCollection.reloadData()
            }
        }

    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchingBook {
            return filteredBooks.count
        }
        if collectionView == cookBooksCollection{
            return cookBooks.count
        }
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        func cell(cellIdentifier: String) -> UICollectionViewCell {
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            bookCell.backgroundColor = UIColor.yellow
            return bookCell
        }
        
        if isSearchingBook {
            /*
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookSearchCell", for: indexPath)
            bookCell.backgroundColor = UIColor.yellow
            return bookCell
             */
            return cell(cellIdentifier: "bookSearchCell")
        }

        
        if collectionView == generalBooksCollection {
            /*
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "generalBookCell", for: indexPath) as! GeneralBooksCollectionViewCell
            bookCell.backgroundColor = UIColor.yellow
            return bookCell
            */
            return cell(cellIdentifier: "generalBookCell") as! GeneralBooksCollectionViewCell
        }
        else if collectionView == technicalBooksCollection {
            /*
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "technicalBookCell", for: indexPath) as! TechnicalBooksCollectionViewCell
            bookCell.backgroundColor = UIColor.yellow
            return bookCell
            */
            return cell(cellIdentifier: "technicalBookCell") as! TechnicalBooksCollectionViewCell
        }
        else if collectionView == cookBooksCollection{
            
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cookBookCell", for: indexPath) as! CookBooksCollectionViewCell
            /*let imgUrl = cookBooks[indexPath.row].volumeInfo.imageLinks.thumbnail
            if let imageUrl = URL(string: imgUrl){
                do{
                    let data = try Data(contentsOf: imageUrl)
                    bookCell.imageBackground.image = UIImage(data: data)
                }catch{
                    print("Error loading image")
                }
                
            }*/
            bookCell.title.text = cookBooks[indexPath.row].volumeInfo.title
            bookCell.author.text = cookBooks[indexPath.row].volumeInfo.authors[0]
            bookCell.backgroundColor = .white
            return bookCell
             
           // return cell(cellIdentifier: "cookBookCell") as! CookBooksCollectionViewCell

        }else{
            return cell(cellIdentifier: "bookSearchCell")
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
            bookPDFController.bookName = cookBooks[indexPath.row].volumeInfo.previewLink
            

        }
        navigationController?.pushViewController(bookPDFController, animated: true)
    }
    
    func fetchBooks(booksCompletionHandler: @escaping (BooksApi) -> ()){
       // let urlString = "https://books.google.com/books?uid=110997512389116888553&as_coll=1001&source=gbs_lp_bookshelf_list&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY" //book shelf
        //"https://www.googleapis.com/books/v1/volumes?q=flowers+inauthor:keyes&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY"
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=cookpdf&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY" // works
        //let urlString = "https://www.googleapis.com/books/v1/volumes?q=technicalbookpdf&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY" //works
        //let urlString = "https://www.googleapis.com/books/v1/volumes?q=generalbookpdf&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY" //works
        let fetchURL = URL(string: urlString)
        
        guard fetchURL != nil else{
            print("Error ---> fetching Books Url")
            return
        }
        
        let bookDataTask = URLSession.shared.dataTask(with: fetchURL!){data, response, error in
            guard let data = data else {
                print("Data is nil")
                return
            }
            do{
                let decodedBooks = try JSONDecoder().decode(BooksApi.self, from: data)
                for book in decodedBooks.items {
                    self.cookBooks.append(book)
                    print(book.volumeInfo.authors, book.volumeInfo.title)
                    print(book.volumeInfo.imageLinks.thumbnail)
                    print(book.v)
                }
                booksCompletionHandler(decodedBooks)
            }catch{
                print("Error ---> Decoding books")
            }
        }
        bookDataTask.resume()
        
    }

}
// Implements search bar and display content of the search
extension BooksViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            filteredBooks = books.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
            isSearchingBook = true
            searchBooksCollection.isHidden = false

            self.searchBooksCollection.reloadData()
            
        }else{
            isSearchingBook = true
            searchBooksCollection.isHidden = false
        }
        isSearchingBook = false
    }
}

struct BooksApi: Codable {
    var kind: String
    var items: [Books]
   /* var status: String
    var copyright: String
    var num_results: Int
    var last_modified: String
    var results: [BookDetails]*/
    
    //var results: [String]
}
struct Books: Codable{
    var kind, id, etag, selfLink: String
    var volumeInfo: BookDetails
    var accessInfo: AccessInfo
    
}
struct BookDetails: Codable{
    //AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY google api-key
    var title: String
    var authors: [String]
    var publisher, publishedDate, description: String
    var industryIdentifiers: [IndustryIdentifiers]
    var readingModes: ReadingModes
    var pageCount: Int
    var printType: String
    var categories: [String]
    //var averageRating, ratingsCount: Int
    var maturityRating: String
    var imageLinks: ImageLinks
    var previewLink: String

}
struct AccessInfo: Codable{
    var webReaderLink: String
}
struct IndustryIdentifiers: Codable{
    var type, identifier: String
}
struct ReadingModes: Codable{
    var text, image: Bool
}
struct ImageLinks: Codable{
    var smallThumbnail, thumbnail: String
}
