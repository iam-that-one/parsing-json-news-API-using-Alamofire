//
//  ArticlesViewModel.swift
//  articles-Alamofire
//
//  Created by Abdullah Alnutayfi on 05/04/2021.
//

import Foundation
import Alamofire
class AriclesViewModel: ObservableObject{
   
    @Published var articles = [Articles]()
   //https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=
    //https://newsapi.org/v2/everything?q=apple&from=2021-04-02&to=2021-04-02&sortBy=popularity&apiKey=
    func fetchData(){
    let API_KEY = ""
    let API_URL = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=\(API_KEY)"
    AF.request(API_URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response{ (response) in
        guard let data = response.data else{return}
        do{
        let request = try JSONDecoder().decode(News.self, from: data)
            print(request)
            DispatchQueue.main.async {
                self.articles = request.articles.compactMap(){$0}
            }
        }catch{
            print(error.localizedDescription)
        }
    }
        
    
          
   
 
    }
    var dateFormatter : DateFormatter?{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    func loadImage(ImageUrl: String) -> Data?{
        guard let url = URL(string: ImageUrl) else {return Data()}
        if let data = try? Data(contentsOf: url){
            return data
        }
        return nil
    }
}
struct News : Codable{
    var articles : [Articles]
}

struct Articles : Codable,Identifiable {
    var title : String?
    var author : String?
    var description : String?
    var url : String?
    var urlToImage : String?
    var publishedAt : String
    var content : String?
    var id : String?{
        url
    }
    var date : Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:publishedAt)!
        return date
    }
  
}


