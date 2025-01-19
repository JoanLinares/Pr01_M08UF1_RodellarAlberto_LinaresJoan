import Foundation

class CardListViewModel: ObservableObject {
    @Published var cards: [Card] = [] // Todas las cartas
    @Published var filteredCards: [Card] = [] // Cartas filtradas
    @Published var error: AppError? // Manejo de errores
    @Published var isEmptySearchResult: Bool = false // Indica si no se encontró ninguna carta
    @Published var types: [String] = [] // Lista de tipos de cartas disponibles
    
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
                                self?.filteredCards = self?.cards ?? []
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
    
    // Cargar todos los tipos
    func fetchAllTypes() {
        api.fetchAllTypes { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedTypes):
                    self?.types = fetchedTypes + ["Trainer"]
                case .failure(let error):
                    self?.error = AppError(message: error.localizedDescription)
                }
            }
        }
    }
    
    // Buscar cartas por nombre o ID
    func searchCards(by searchText: String) {
        if searchText.isEmpty {
            filteredCards = cards // Si no hay texto de búsqueda, mostrar todas las cartas
            isEmptySearchResult = false
        } else {
            if searchText.rangeOfCharacter(from: .decimalDigits) != nil {
                filteredCards = cards.filter { card in
                    card.id.split(separator: "-").last?.lowercased() == searchText.lowercased()
                }
                isEmptySearchResult = filteredCards.isEmpty
            } else {
                filteredCards = cards.filter { card in
                    card.name.lowercased().contains(searchText.lowercased()) // Comparar nombres de cartas
                }
                isEmptySearchResult = filteredCards.isEmpty // Si no hay cartas filtradas, marcar como vacío
            }
        }
    }
    
    // Filtrar cartas por tipo
    func filterCards(by type: String) {
        if type.isEmpty {
            filteredCards = cards // Si no hay tipo especificado, mostrar todas las cartas
            isEmptySearchResult = false
        } else {
            if type == "trainer" {
                filteredCards = cards.filter { card in
                    card.supertype.lowercased() == type.lowercased()
                }
            } else {
                filteredCards = cards.filter { card in
                    guard let cardTypes = card.types else { return false }
                    return cardTypes.contains { $0.lowercased() == type.lowercased() }
                }
            }
            isEmptySearchResult = filteredCards.isEmpty // Indicar si no se encontraron cartas
        }
    }
    
    // Método para ordenar las cartas
    private func sortCards(_ cards: [Card]) -> [Card] {
        return cards.sorted { card1, card2 in
            guard
                let id1 = Int(card1.id.split(separator: "-").last ?? ""),
                let id2 = Int(card2.id.split(separator: "-").last ?? "")
            else {
                return false
            }
            return id1 < id2
        }
    }
}
