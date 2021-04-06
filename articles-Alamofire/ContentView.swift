//
//  ContentView.swift
//  articles-Alamofire
//
//  Created by Abdullah Alnutayfi on 05/04/2021.
//

import SwiftUI
import Alamofire
struct ContentView: View {
    init() {
        UINavigationBar.appearance().barTintColor = .yellow
    }
    @State private var imagePreviewstillLoding = false
    @State private var stillLoding = true
    @State private var zoomIn = false
    @State private var currentImage = UIImage()
    @StateObject var avm = AriclesViewModel()
    var body: some View {
        NavigationView{
            ZStack(){
                Color.green.opacity(0.30)
                if stillLoding{
                  ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1)
                }
             //   if imagePreviewstillLoding{
                 // ProgressView()
                 //   .progressViewStyle(CircularProgressViewStyle())
                  //  .scaleEffect(1)
               // }
        VStack(alignment: .leading){
            ScrollView(showsIndicators: false){
           
            ForEach(avm.articles){ article in
                VStack(alignment: .leading){
                    HStack{
                        Image(uiImage: (UIImage(data: avm.loadImage(ImageUrl: article.urlToImage ?? "https://i.pinimg.com/564x/6f/de/85/6fde85b86c86526af5e99ce85f57432e.jpg") ?? Data()) ?? UIImage(systemName: "star"))!)
                       
                    .resizable()
                        
                        .scaledToFit()
                            .frame(width: 100, height: 100)
                        .padding(.leading)
                        .onTapGesture{
                            currentImage = UIImage(data: avm.loadImage(ImageUrl: article.urlToImage ?? "") ?? Data()) ?? UIImage()
                                
                        withAnimation(){
                            zoomIn = true
                            //imagePreviewstillLoding = true
                            }
                        }
                        
                        VStack(alignment: .leading){
                            Text("Author:")
                                .font(Font.system(size: 12, weight: .black, design: .monospaced))
                        if let author = article.author{
                            if author.contains("http"){
                                Link("author website", destination: URL(string: author)!)
                            }
                            else{
                                Text(article.author ?? "")
                            }
                            Text("\(article.date,formatter: avm.dateFormatter)")
                               .font(Font.system(size: 12))
                           
                        }
                    }
                       
                          
                        Spacer()
                    }.background(Color.yellow)
                    .onAppear{stillLoding = false}
                Text(article.title ?? "")
                    .fontWeight(.bold)
                    .padding(.leading)
                    Text(article.description ?? "")
                        .font(Font.system(size: 12,design: .serif))
                        .padding()
                   
                    Text(article.content ?? "")
                    .font(.body)
                        .padding(.leading)
                    Link("Read more",destination: URL(string: article.url ?? "")!)
                        .padding(.leading)
            }
            }
            
        }.navigationBarTitle(Text("News"), displayMode: .inline)
            .frame(height: UIScreen.main.bounds.height - 100)
            .offset(y: 30)
            .onTapGesture {
                withAnimation(.spring()){
                zoomIn = false
                }
            }
        }.onAppear{avm.fetchData()}
        .frame(height: UIScreen.main.bounds.height - 100)
       // .padding(.leading)
        
                if zoomIn == true{
                    Color.white.opacity(0.80)
                  
                        
                    ZStack(alignment: .topLeading){

                    Image(uiImage: currentImage)
                        .resizable()
                        .frame(width: 350, height: 300)
                        .scaledToFit()
                        .transition((.move(edge: .bottom)))
                       // .animation(zoomIn == true ? Animation.easeIn : Animation.easeInOut)
                        Image(systemName: zoomIn == true ? "x.square.fill" : "x.square")
                            .foregroundColor(.white)
                            .shadow(color: .black,radius: 10)
                            
                            .onTapGesture {
                                withAnimation(){
                            zoomIn = false
                                
                          //  imagePreviewstillLoding = false
                                }
                        }
                    
                    }
                }//.onAppear(){stillLoding = false}
            
            }.ignoresSafeArea()
            
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
