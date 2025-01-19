import Foundation

struct Deck: Codable, Identifiable {
    let id: String
    var name: String
    var cards: [Card] // Lista de cartas en el deck
    var type: String // Tipo del deck
    var featuredCard: Card? // Carta destacada del deck

    // Asegurar que no se pueda tener más de 20 cartas
    mutating func addCard(_ card: Card) -> Bool {
        if cards.count < 20 {
            cards.append(card)
            return true
        }
        return false // No se agrega si ya tiene 20 cartas
    }
}
