//
//  SearchViewModel.swift
//  TakeItEasy
//
//  Created by Philip Janzel Paradeza on 2022-06-08.
//

import Foundation
import WebKit
class SearchViewModel{
    
    func displayGoogle() -> WKWebView{
        let webKitView = WKWebView()
        let newURL = URL(string: "https://www.google.com")!
        webKitView.load(URLRequest(url: newURL))
        return webKitView
    }
}
