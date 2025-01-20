import Foundation

class CardListViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var filteredCards: [Card] = []
    @Published var error: AppError?
    @Published var isEmptySearchResult: Bool = false
    @Published var types: [String] = []
    
    private let api = PokemonAPI()
    
    private var searchText: String = ""
    private var selectedType: String? = nil
    
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
                                self?.applyFilters()
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
    
    func updateSearchText(_ text: String) {
        searchText = text
        applyFilters()
    }
    
    func updateSelectedType(_ type: String?) {
        selectedType = type
        applyFilters()
    }
    
    private func applyFilters() {
        filteredCards = cards.filter { card in
            let matchesSearchText = searchText.isEmpty || card.name.lowercased().contains(searchText.lowercased()) || card.id.lowercased() == searchText.lowercased()
            let matchesType = selectedType == nil || selectedType!.isEmpty || (selectedType!.lowercased() == "trainer" && card.supertype.lowercased() == "trainer") || (card.types?.contains { $0.lowercased() == selectedType!.lowercased() } ?? false)
            return matchesSearchText && matchesType
        }
        isEmptySearchResult = filteredCards.isEmpty
    }
    
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
