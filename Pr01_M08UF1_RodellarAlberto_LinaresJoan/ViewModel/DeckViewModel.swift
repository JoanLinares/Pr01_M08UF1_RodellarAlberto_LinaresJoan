import Foundation

class DeckViewModel: ObservableObject {
    @Published var decks: [Deck] = [] // Lista de decks
    @Published var selectedDeck: Deck? // Deck actualmente seleccionado
    @Published var error: AppError? // Manejo de errores
    
    // Función para crear un nuevo deck
    func createDeck(name: String, type: String, cards: [Card], featuredCard: Card?) {
        let newDeck = Deck(id: UUID().uuidString, name: name, cards: cards, type: type, featuredCard: featuredCard)
        decks.append(newDeck)
    }
    
    // Función para establecer una carta destacada
    func setFeaturedCard(for deck: Deck, card: Card) {
        var updatedDeck = deck
        updatedDeck.featuredCard = card
        
        if let index = decks.firstIndex(where: { $0.id == deck.id }) {
            decks[index] = updatedDeck
        }
    }
    
    // Función para buscar un deck por nombre
    func searchDeck(by name: String) {
        if name.isEmpty {
            // Mostrar todos los decks
        } else {
            decks = decks.filter { $0.name.lowercased().contains(name.lowercased()) }
        }
    }
}
