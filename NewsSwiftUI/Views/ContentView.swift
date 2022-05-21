//
//  ContentView.swift
//  NewsSwiftUI
//
//  Created by  Юлия Григорьева on 19.05.2022.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var networkManager = NetworkManager() // создаем объект класса, инициализируем и добавляем property wrapper для слушателя уведомлений (подписываемся на изменения из NetworkManager). Когда будут изменения то будет выполняться и мы можем использовать networkManager.posts чтобы обновлять список

    var body: some View {
        NavigationView {
            List(networkManager.posts) { post in
                NavigationLink(destination: DetailView(url: post.url)) {
                    HStack {
                        Text(String(post.points))
                        Text(post.title)
                    }
                }
            }
        .navigationBarTitle("Hacker News")
    }
        .onAppear {
            self.networkManager.fetchData()
        } //метод аналогичный viewDidLoad передаем функцию кот будет выполняться когда view появится на экране
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



