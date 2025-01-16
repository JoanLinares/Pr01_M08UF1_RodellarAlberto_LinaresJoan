import Foundation

class CardListViewModel: ObservableObject {
    @Published var cards: [Card] = [] // Todas las cartas
    @Published var filteredCards: [Card] = [] // Cartas filtradas
    @Published var error: AppError? // Manejo de errores
    @Published var isEmptySearchResult: Bool = false // Indica si no se encontró ninguna carta

    private let api = PokemonAPI() // Instancia de la clase API

    // Cargar todas las cartas
    func fetchAllCards() {
        api.fetchLatestCollection { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let collectionID):
                    self?.api.fetchCards(fromCollection: collectionID) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let fetchedCards):
                                self?.cards = self?.sortCards(fetchedCards) ?? []
                                self?.filteredCards = self?.cards ?? []  // Asignar filteredCards al cargar
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

    // Filtrar las cartas según el nombre
    func filterCards(by searchText: String) {
        if searchText.isEmpty {
            filteredCards = cards // Si no hay texto de búsqueda, mostrar todas las cartas
            isEmptySearchResult = false
        } else {
            filteredCards = cards.filter { card in
                card.name.lowercased().contains(searchText.lowercased()) // Comparar nombres de cartas
            }
            isEmptySearchResult = filteredCards.isEmpty // Si no hay cartas filtradas, marcar como vacío
        }
    }

    // Método para ordenar las cartas
    private func sortCards(_ cards: [Card]) -> [Card] {
        return cards.sorted { card1, card2 in
            guard let id1 = Int(card1.id.dropFirst(4)),
                  let id2 = Int(card2.id.dropFirst(4)) else {
                return false
            }
            return id1 < id2
        }
    }
}
