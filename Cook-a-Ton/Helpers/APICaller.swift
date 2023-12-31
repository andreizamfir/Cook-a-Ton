//
//  APICaller.swift
//  Cook-a-Ton
//
//  Created by Andrei Zamfir on 11.09.2023.
//

import Foundation
import Combine

// MARK: - Source
// https://medium.com/@hemalasanka/making-api-calls-with-ios-combines-future-publisher-7a5011f81c2


// MARK: - Error types

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        }
    }
}


// MARK: - Singleton NetworkManager

class APICaller{
    static let shared = APICaller()
    
    private var cancellables = Set<AnyCancellable>()
        
     func getData<T: Decodable>(endpoint: String, id: Int? = nil, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: endpoint) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: {  data in
                    promise(.success(data))
                })
                .store(in: &self.cancellables)
        }
    }
    
}
