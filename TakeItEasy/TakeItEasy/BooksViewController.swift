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
   
    
    var filteredBooks = [Books]()
    var isSearchingBook = false
    var allBooksCollection = [Books]()
    
    var cookBooks = [Books]()
    var generalBooks = [Books]()
    var technicalBooks = [Books]()
    
    var allBooks = [Books]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookUrlDecoder(aUrlString: "https://www.googleapis.com/books/v1/volumes?q=cookpdf&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY", count: 2){
            DispatchQueue.main.async{
                self.cookBooksCollection.reloadData()
            }
        }
        bookUrlDecoder(aUrlString: "https://www.googleapis.com/books/v1/volumes?q=technicalbookpdf&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY", count: 1){
            DispatchQueue.main.async{
                self.technicalBooksCollection.reloadData()
            }
        }
        
        bookUrlDecoder(aUrlString: "https://www.googleapis.com/books/v1/volumes?q=all+bookpdf&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY", count: 0){
            DispatchQueue.main.async{
                self.generalBooksCollection.reloadData()
            }
        }

    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchingBook {
            return filteredBooks.count
        }else if collectionView == cookBooksCollection{
            return cookBooks.count
        }else if collectionView == technicalBooksCollection{
            return technicalBooks.count
        }else if collectionView == generalBooksCollection{
            return generalBooks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        func cell(cellIdentifier: String) -> UICollectionViewCell {
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            bookCell.backgroundColor = UIColor.yellow
            return bookCell
        }
        
        if collectionView == searchBooksCollection {
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookSearchCell", for: indexPath) as! BookSearchCollectionViewCell
            
            let imgUrl = filteredBooks[indexPath.row].volumeInfo.imageLinks.thumbnail
            if let imageUrl = URL(string: imgUrl){
                do{
                    let data = try Data(contentsOf: imageUrl)
                    bookCell.imageBackground.image = UIImage(data: data)
                }catch{
                    print("Error loading image")
                }
            }
            return bookCell
             
        
        }else if collectionView == generalBooksCollection {
            
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "generalBookCell", for: indexPath) as! GeneralBooksCollectionViewCell
            
            let imgUrl = generalBooks[indexPath.row].volumeInfo.imageLinks.thumbnail
            if let imageUrl = URL(string: imgUrl){
                do{
                    let data = try Data(contentsOf: imageUrl)
                    bookCell.imageBackground.image = UIImage(data: data)
                }catch{
                    print("Error loading image")
                }
                
            }

            
            return bookCell
            
            //return cell(cellIdentifier: "generalBookCell") as! GeneralBooksCollectionViewCell
        }
        else if collectionView == technicalBooksCollection {
            
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "technicalBookCell", for: indexPath) as! TechnicalBooksCollectionViewCell
            
            let imgUrl = technicalBooks[indexPath.row].volumeInfo.imageLinks.thumbnail
            if let imageUrl = URL(string: imgUrl){
                do{
                    let data = try Data(contentsOf: imageUrl)
                    bookCell.imageBackground.image = UIImage(data: data)
                }catch{
                    print("Error loading image")
                }
                
            }
            return bookCell
            
            //return cell(cellIdentifier: "technicalBookCell") as! TechnicalBooksCollectionViewCell
        }
        else /*if collectionView == cookBooksCollection*/{
            
            let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cookBookCell", for: indexPath) as! CookBooksCollectionViewCell
            //--------------------------------------------------------------------------------
            let imgUrl = cookBooks[indexPath.row].volumeInfo.imageLinks.thumbnail
            if let imageUrl = URL(string: imgUrl){
                do{
                    let data = try Data(contentsOf: imageUrl)
                    bookCell.imageBackground.image = UIImage(data: data)
                }catch{
                    print("Error loading image")
                }
                
            }

            return bookCell

        }/*else{
            return cell(cellIdentifier: "bookSearchCell") as! BookSearchCollectionViewCell
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyObject = UIStoryboard(name: "Main", bundle: nil)
        let bookPDFController = storyObject.instantiateViewController(withIdentifier: "bookPDF") as! BookPDFViewController
        if isSearchingBook {
            bookPDFController.bookName = filteredBooks[indexPath.row].volumeInfo.previewLink
        }else if collectionView == generalBooksCollection{
            bookPDFController.bookName = generalBooks[indexPath.row].volumeInfo.previewLink
        }else if (collectionView == technicalBooksCollection) {
            bookPDFController.bookName = technicalBooks[indexPath.row].volumeInfo.previewLink
        } else{
            bookPDFController.bookName = cookBooks[indexPath.row].volumeInfo.previewLink
            

        }
        navigationController?.pushViewController(bookPDFController, animated: true)
    }

    //--------------------------------------------------------------------------------------------------------------------------------------
    func bookUrlDecoder(aUrlString: String, count: Int, completion: @escaping () -> ()){

        let fetchURL = URL(string: aUrlString)
        
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
                    if !book.volumeInfo.previewLink.isEmpty{
                        switch count {
                        case 0:
                            self.generalBooks.append(book)
                            self.allBooksCollection.append(book)
                        case 1:
                            self.technicalBooks.append(book)
                            self.allBooksCollection.append(book)
                        case 2:
                            self.cookBooks.append(book)
                            self.allBooksCollection.append(book)
                        default:
                            print("None of the counts")
                        }

                        }
                }
                completion()
            }catch{
                print("Error ---> Decoding books")
            }
        }
        bookDataTask.resume()
    }
    //--------------------------------------------------------------------------------------------------------------------------------------
}
// Implements search bar and display content of the search
extension BooksViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBooks = searchText.isEmpty ? allBooksCollection : allBooksCollection.filter({$0.volumeInfo.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        self.searchBooksCollection.isHidden = false
        
        self.generalBooksCollection.isHidden = true
        self.generalBooksCollection.reloadData()
        
        self.cookBooksCollection.isHidden = true
        self.cookBooksCollection.reloadData()
        
        self.technicalBooksCollection.isHidden = true
        self.technicalBooksCollection.reloadData()
        
        isSearchingBook = true
        self.searchBooksCollection.reloadData()
        
        }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBooksCollection.isHidden = true
        
        self.generalBooksCollection.isHidden = false
        self.generalBooksCollection.reloadData()
        
        self.cookBooksCollection.isHidden = false
        self.cookBooksCollection.reloadData()
        
        self.technicalBooksCollection.isHidden = false
        self.technicalBooksCollection.reloadData()
        
        self.searchBooksCollection.reloadData()
        searchBar.resignFirstResponder()
    }
}

struct BooksApi: Codable {
    //var kind: String
    var items: [Books]
}
struct Books: Codable{
    //var kind, id, etag, selfLink: String
    var volumeInfo: BookDetails
    //var accessInfo: AccessInfo
    
}
struct BookDetails: Codable{
    //AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY google api-key
    var title: String
    var authors: [String]
    var publisher, publishedDate, description: String
    //var industryIdentifiers: [IndustryIdentifiers]
    //var readingModes: ReadingModes
    //var pageCount: Int
    //var printType: String
    //var categories: [String]
    //var maturityRating: String
    var imageLinks: ImageLinks
    var previewLink: String

}
/*
struct AccessInfo: Codable{
    var webReaderLink: String
}
struct IndustryIdentifiers: Codable{
    var type, identifier: String
}
struct ReadingModes: Codable{
    var text, image: Bool
}*/
struct ImageLinks: Codable{
    var smallThumbnail, thumbnail: String
}
