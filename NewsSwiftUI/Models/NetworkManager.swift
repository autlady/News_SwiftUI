//
//  NetworkManager.swift
//  NewsSwiftUI
//
//  Created by  Юлия Григорьева on 21.05.2022.
//

import Foundation

class NetworkManager: ObservableObject { // протокол делает класс видимым и тогда одно из свойств может быть публчиным, и чтобы уведомлять слушателей  когда будут изменения и чтобы установаить слушателя мы добавляем к свойству обертку @ObservedObject (в контент вью)

    @Published var posts = [Post]() // чтобы сделать  Posts публичными  нужен property wrapper (обертка над свойством кот-я добавляет логику к этому свойству и когда используем @Published нам надо быть уверенными что мы используем основной поток main thread

    func fetchData() { //получить данные
        if let url = URL(string: "http://hn.algolia.com/api/v1/search?tags=front_page") {// создаем URL из URL инициализатора, получаем опционал - поэтому optional binding. Если мы сможем сгенерировать URL bз этого String то:
            let session = URLSession(configuration: .default) //создаем объект сессия класса URLSession и инициализируем его используя дефолтную конфигурацию
            let task = session.dataTask(with: url) { (data, response, error) in // создаем задачу которую устанавливаем как session.dataTask и используем инициализатор который принимает URL который мы создали  и имеет СompletionHandler с данными которые мы возвращаем как ответ и error
                if error == nil { // внутри замыкания проверяем если не было error то мы предполагаем что получаем данные в формате JSON которые нужно преобразовать
                    let decoder = JSONDecoder() // создаем decoder
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(Results.self, from: safeData) // используем декодер для данных типа структуры Result и данные приходят из data но они опциональные поэтому используя optional binding мы создаем сначала safeData. Метод decode может вызвать ошибку поэтому добавляется try и конструкция do catch чтобы обработать ошибку
                            DispatchQueue.main.async { // изменения должны происходить на главном потоке
                                self.posts = results.hits
                            }

                        } catch {
                            print(error)
                        }
                    }
                }

            }
            task.resume()// запускаем задачу
        }
    }
}
