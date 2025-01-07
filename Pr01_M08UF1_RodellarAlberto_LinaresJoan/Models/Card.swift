import Foundation

// Modelo para una carta Pokémon
struct Card: Codable, Identifiable {
    let id: String
    let name: String
    let images: CardImages
    let cardmarket: CardMarket?
    var setID: String? // Propiedad mutable para guardar el setID
    let number: String // Número de la carta
}

// Modelo para las imágenes de la carta
struct CardImages: Codable {
    let small: String
    let large: String
}

// Modelo para el mercado de cartas
struct CardMarket: Codable {
    let prices: MarketPrices
}

// Precios del mercado
struct MarketPrices: Codable {
    let averageSellPrice: Double?
    let lowPrice: Double?
    let trendPrice: Double?
}
