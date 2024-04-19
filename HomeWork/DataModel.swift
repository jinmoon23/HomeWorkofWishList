//
//  DataModel.swift
//  HomeWork
//
//  Created by 최진문 on 2024/04/12.
//

import Foundation

struct DataModel: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let thumbnail: String
}

enum DataError: Error {
    case networkError
    case parsingError
}

enum DataState {
    case loading
    case success
    case error
}

class DataViewModel {
    var data: DataModel?
    var error: DataError?
    var state: DataState = .loading
    
    func fetchData(from url: URL, completion: @escaping () -> Void) {
        state = .loading
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                   self?.error = .networkError
                   self?.state = .error
                   print("Network Error: \(error.localizedDescription)")
               } else if let data = data {
                   do { // url을 받아와 JSON data를 Swift타입으로 변환한다.
                       self?.data = try JSONDecoder().decode(DataModel.self, from: data)
                       self?.state = .success
                   } catch {
                       self?.error = .parsingError
                       self?.state = .error
                       print("Parsing Error: \(error.localizedDescription)")
                   }
               }
               completion()
           }.resume()
       }
   }



