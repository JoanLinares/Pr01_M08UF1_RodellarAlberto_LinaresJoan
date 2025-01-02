import Foundation

class PokemonAPI {
    private let baseURL = "https://api.pokemontcg.io/v2"
    private let apiKey = "a1758e34-8404-4445-a047-c186c07419a2"
    
    // MARK: - Obtener ID de la Última Colección
    func fetchLatestCollection(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sets?orderBy=-releaseDate") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching latest collection: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SetResponse.self, from: data)
                if let latestSet = response.data.first {
                    print("Latest collection ID: \(latestSet.id)")
                    completion(.success(latestSet.id))
                } else {
                    completion(.failure(NSError(domain: "No sets found", code: -1, userInfo: nil)))
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Obtener Cartas de una Colección
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
                print("Error fetching cards: \(error.localizedDescription)")
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
                print("Fetched cards from collection: \(response.data.count) cards")
                completion(.success(response.data))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - Modelos de Datos

// Modelo para la respuesta del conjunto (colección)
struct SetResponse: Codable {
    let data: [Set]
}

struct Set: Codable {
    let id: String
    let name: String
    let releaseDate: String
}

// Modelo para la respuesta de cartas
struct CardResponse: Codable {
    let data: [Card]
}

struct Card: Codable {
    let id: String
    let name: String
    let images: CardImages
    let cardmarket: CardMarket?
}

struct CardImages: Codable {
    let small: String
    let large: String
}

struct CardMarket: Codable {
    let prices: MarketPrices
}

struct MarketPrices: Codable {
    let averageSellPrice: Double?
    let lowPrice: Double?
    let trendPrice: Double?
}
