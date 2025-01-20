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
    
    // Función para eliminar un deck
    func deleteDeck(id: String) {
        if let index = decks.firstIndex(where: { $0.id == id }) {
            decks.remove(at: index)
        }
    }
    
    // Función para editar un deck
    func updateDeck(id: String, newName: String?, newType: String?, newCards: [Card]?, newFeaturedCard: Card?) {
        if let index = decks.firstIndex(where: { $0.id == id }) {
            var updatedDeck = decks[index]
            
            // Actualizamos las propiedades solo si los nuevos valores no son nil
            if let newName = newName {
                updatedDeck.name = newName
            }
            if let newType = newType {
                updatedDeck.type = newType
            }
            if let newCards = newCards {
                updatedDeck.cards = newCards
            }
            if let newFeaturedCard = newFeaturedCard {
                updatedDeck.featuredCard = newFeaturedCard
            }
            
            // Reemplazamos el deck original con el deck actualizado
            decks[index] = updatedDeck
        }
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
