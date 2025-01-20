import Foundation

class PokemonAPI {
    private let baseURL = "https://api.pokemontcg.io/v2"
    private let apiKey = "a1758e34-8404-4445-a047-c186c07419a2"
    
    func fetchLatestCollection(completion: @escaping (Result<String, Error>) -> Void) {
        /*guard let url = URL(string: "\(baseURL)/sets?q=name:\"Surging Sparks\"") else {
         completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))*/
        completion(.success("sv8"))
    }
    
    func fetchCards(fromCollection collectionID: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/cards?q=set.id:\(collectionID)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(CardResponse.self, from: data)
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Modelos de Datos
    struct SetResponse: Codable {
        let data: [Set]
    }
    
    struct Set: Codable {
        let id: String
        let name: String
        let releaseDate: String
    }
    
    struct CardResponse: Codable {
        let data: [Card]
    }
}
