import Foundation

class MenuViewModel: ObservableObject {
    @Published var expensiveCards: [Card] = [] // Cartas más caras
    @Published var allCards: [Card] = [] // Todas las cartas del último paquete
    @Published var error: AppError? // Mostrar errores

    private let api = PokemonAPI() // Instancia de la clase API

    // Cargar las cartas del último paquete y seleccionar las 6 más caras
    func loadExpensiveCards() {
        api.fetchLatestCollection { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let collectionID):
                    self?.api.fetchCards(fromCollection: collectionID) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let cards):
                                self?.allCards = cards
                                let sortedCards = cards
                                    .filter { $0.cardmarket?.prices.trendPrice != nil }
                                    .sorted { ($0.cardmarket?.prices.trendPrice ?? 0) > ($1.cardmarket?.prices.trendPrice ?? 0) }

                                self?.expensiveCards = Array(sortedCards.prefix(6)) // Selecciona las 6 más caras
                            case .failure(let error):
                                self?.error = AppError(message: error.localizedDescription)
                            }
                        }
                    }
                case .failure(let error):
                    self?.error = AppError(message: error.localizedDescription)
                }
            }
        }
    }

    // Buscar carta por número en el último set
    func findCard(byNumber number: String) -> Card? {
        guard let latestSetID = allCards.first?.setID else {
            print("Error: No set ID available in loaded cards.")
            return nil
        }

        return allCards.first { $0.number == number && $0.setID == latestSetID }
    }
}

// Modelo para manejar errores
struct AppError: Identifiable {
    let id = UUID()
    let message: String
}
