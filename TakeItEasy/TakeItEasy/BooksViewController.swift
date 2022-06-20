//
//  BooksViewController.swift
//  TakeItEasy
//
//  Created by admin on 6/8/22.
//

import UIKit


class BooksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //These are collection views that will be used
    @IBOutlet weak var searchBooksCollection: UICollectionView!
    @IBOutlet weak var generalBooksCollection: UICollectionView!
    @IBOutlet weak var technicalBooksCollection: UICollectionView!
    @IBOutlet weak var cookBooksCollection: UICollectionView!
   
    //Sectional headers
    @IBOutlet weak var cookBooksTitle: UILabel!
    @IBOutlet weak var technicalBooksTitle: UILabel!
    @IBOutlet weak var generalBooksTitle: UILabel!
    
    var filteredBooks = [Books]()  //filtered books after search
    var isSearchingBook = false
    var allBooksCollection = [Books]() //all books collection
    
    //categories of books
    var cookBooks = [Books]()
    var generalBooks = [Books]()
    var technicalBooks = [Books]()
    
    @IBOutlet weak var userName: UILabel! //user name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = UserSingleton.userData.currentUsername
        
        //Call google api for three collection categories
        bookUrlDecoder(aUrlString: "https://www.googleapis.com/books/v1/volumes?q=cookpdf&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY", count: 2) {
            DispatchQueue.main.async{
                self.cookBooksTitle.text = "Cook Books"
                self.cookBooksCollection.reloadData()
            }
        }
        bookUrlDecoder(aUrlString: "https://www.googleapis.com/books/v1/volumes?q=technicalbookpdf&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY", count: 1) {
            DispatchQueue.main.async{
                self.technicalBooksTitle.text = "Technical Books"
                self.technicalBooksCollection.reloadData()
            }
        }
            
        
        bookUrlDecoder(aUrlString: "https://www.googleapis.com/books/v1/volumes?q=all+bookpdf&key=AIzaSyDHwXKpkrBLBQRgvDqB5fWcshK3vKi-CLY", count: 0) {
            DispatchQueue.main.async{
                self.generalBooksTitle.text = "General Books"
                self.generalBooksCollection.reloadData()
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchBooksCollection {
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
        
        if collectionView == searchBooksCollection {
            var bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookSearchCell", for: indexPath) as! CookBooksCollectionViewCell
            cellBackgroundColorSetter(aCell: &bookCell, index: indexPath.row, books: filteredBooks)
            return bookCell
        
        }else if collectionView == generalBooksCollection {
            var bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "generalBookCell", for: indexPath) as! CookBooksCollectionViewCell
            cellBackgroundColorSetter(aCell: &bookCell, index: indexPath.row, books: generalBooks)
            return bookCell
        }else if collectionView == technicalBooksCollection {
            var bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "technicalBookCell", for: indexPath) as! CookBooksCollectionViewCell
            cellBackgroundColorSetter(aCell: &bookCell, index: indexPath.row, books: technicalBooks)
            return bookCell
        }else{
            var bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cookBookCell", for: indexPath) as! CookBooksCollectionViewCell
            cellBackgroundColorSetter(aCell: &bookCell, index: indexPath.row, books: cookBooks)
            return bookCell

        }
        
    }
    // sets cell background cover
    func cellBackgroundColorSetter(aCell: inout CookBooksCollectionViewCell, index: Int, books: [Books]){
        let imgUrl = books[index].volumeInfo.imageLinks.thumbnail
        if let imageUrl = URL(string: imgUrl){
            do{
                let data = try Data(contentsOf: imageUrl)
                aCell.imageBackground.image = UIImage(data: data)
            }catch{
                print("Error loading image")
            }
            
        }

    }
    
    @IBAction func bookLogOutButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
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

    //decodes google books apis
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

}
// Implements search bar and display content of the search
extension BooksViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBooks = searchText.isEmpty ? allBooksCollection : allBooksCollection.filter({
            $0.volumeInfo.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        statusModifier(currentStatus: true)
        }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        statusModifier(currentStatus: false)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func statusModifier(currentStatus: Bool){
        self.searchBooksCollection.isHidden = !currentStatus
        
        self.generalBooksCollection.isHidden = currentStatus
        self.generalBooksCollection.reloadData()
        
        self.cookBooksCollection.isHidden = currentStatus
        self.cookBooksCollection.reloadData()
        
        self.technicalBooksCollection.isHidden = currentStatus
        self.technicalBooksCollection.reloadData()
        
        self.searchBooksCollection.reloadData()
    }
}

struct BooksApi: Codable {
    var items: [Books]
}
struct Books: Codable{
    var volumeInfo: BookDetails
}
struct BookDetails: Codable{
    var title: String
    var authors: [String]
    var imageLinks: ImageLinks
    var previewLink: String

}

struct ImageLinks: Codable{
    var smallThumbnail, thumbnail: String
}
