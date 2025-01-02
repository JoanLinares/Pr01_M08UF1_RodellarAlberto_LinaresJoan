import Foundation

class MenuViewModel: ObservableObject {
    @Published var expensiveCards: [Card] = [] // Cartas más caras
    @Published var error: AppError? // ostrar errores

    private let api = PokemonAPI() // Instancia de la clase API

    // Cargar las cartas más caras de la última colcción
    func loadExpensiveCards() {
        // ID última colección
        api.fetchLatestCollection { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let collectionID):
                    print("Última colección obtenida: \(collectionID)")
                    
                    // Obtener cartas
                    self?.api.fetchCards(fromCollection: collectionID) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let cards):
                                print("Cartas obtenidas: \(cards.count) cartas")
                                
                                // Ordenar cartas por precio
                                let sortedCards = cards.filter { $0.cardmarket?.prices.trendPrice != nil }
                                                       .sorted { ($0.cardmarket?.prices.trendPrice ?? 0) > ($1.cardmarket?.prices.trendPrice ?? 0) }
                                
                                // Guardar las 5 cartas más caras
                                self?.expensiveCards = Array(sortedCards.prefix(5))
                            case .failure(let error):
                                self?.error = AppError(message: error.localizedDescription)
                                print("Error al cargar cartas: \(error.localizedDescription)")
                            }
                        }
                    }
                case .failure(let error):
                    self?.error = AppError(message: error.localizedDescription)
                    print("Error al obtener la colección: \(error.localizedDescription)")
                }
            }
        }
    }
}

// Modelo para manejar errores
struct AppError: Identifiable {
    let id = UUID()
    let message: String
}
