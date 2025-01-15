import Foundation

class MenuViewModel: ObservableObject {
    @Published var filteredCards: [Card] = [] // Cartas filtradas por rango de precios
    @Published var displayedCards: [Card] = [] // Cartas visibles en la página actual
    @Published var error: AppError? // Mostrar errores
    @Published var currentPage: Int = 1 // Página actual
    @Published var totalPages: Int = 1 // Número total de páginas
    @Published var maxPriceLimit: Double = 50 // Precio máximo estático

    private let api = PokemonAPI() // Instancia de la clase API
    private var allCards: [Card] = [] // Todas las cartas del último paquete

    // Número de cartas por página (actualizado a 21)
    private let pageSize = 24

    // Cargar cartas ordenadas por precio descendente
    func loadCards() {
        api.fetchLatestCollection { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let collectionID):
                    self?.api.fetchCards(fromCollection: collectionID) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let cards):
                                self?.allCards = cards
                                    .filter { $0.cardmarket?.prices.trendPrice != nil }
                                    .sorted { ($0.cardmarket?.prices.trendPrice ?? 0) > ($1.cardmarket?.prices.trendPrice ?? 0) }
                                self?.resetFilters() // Mostrar todas las cartas al principio
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

    // Restablecer filtros y mostrar todas las cartas
    func resetFilters() {
        filteredCards = allCards
        currentPage = 1
        updatePagination()
    }

    // Actualizar paginación
    func updatePagination() {
        totalPages = max(1, (filteredCards.count + pageSize - 1) / pageSize)
        loadPage() // Cargar las cartas de la página actual
    }

    // Filtrar cartas por rango de precio
    func filterCards(minPrice: Double) {
        if minPrice == 0 {
            // Mostrar todas las cartas en orden descendente (caro a barato)
            filteredCards = allCards.sorted {
                ($0.cardmarket?.prices.trendPrice ?? 0) > ($1.cardmarket?.prices.trendPrice ?? 0)
            }
        } else {
            // Mostrar cartas en orden ascendente (barato a caro) dentro del rango
            filteredCards = allCards.filter {
                let price = $0.cardmarket?.prices.trendPrice ?? 0
                return price >= minPrice
            }.sorted {
                ($0.cardmarket?.prices.trendPrice ?? 0) < ($1.cardmarket?.prices.trendPrice ?? 0)
            }
        }
        currentPage = 1
        updatePagination()
    }

    // Cargar la página actual
    func loadPage() {
        let startIndex = (currentPage - 1) * pageSize
        let endIndex = min(startIndex + pageSize, filteredCards.count)
        guard startIndex < filteredCards.count else {
            displayedCards = []
            return
        }
        displayedCards = Array(filteredCards[startIndex..<endIndex])
    }

    // Cambiar a la página siguiente
    func nextPage() {
        guard currentPage < totalPages else { return }
        currentPage += 1
        loadPage()
    }

    // Cambiar a la página anterior
    func previousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        loadPage()
    }
}

// Modelo para manejar errores
struct AppError: Identifiable {
    let id = UUID()
    let message: String
}
