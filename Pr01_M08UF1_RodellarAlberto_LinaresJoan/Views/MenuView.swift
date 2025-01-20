import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    @State private var minPrice: Double = 0 // Precio mínimo

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            NavigationView {
                VStack(spacing: 8) { // Espaciado reducido entre elementos
                    // Título "Cards" centrado
                    Text("Cards")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8) // Espacio reducido arriba

                    if viewModel.maxPriceLimit > 0 {
                        if isLandscape {
                            // Horizontal: "Filter by Price" y el $0 en la misma línea
                            HStack {
                                Text("Filter by Price")
                                    .font(.headline)
                                Text("$\(Int(minPrice))")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Slider(value: $minPrice, in: 0...viewModel.maxPriceLimit, step: 5)
                                    .onChange(of: minPrice) { newValue in
                                        viewModel.filterCards(minPrice: newValue)
                                    }
                                
                                Text("Max: $\(Int(viewModel.maxPriceLimit))")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                        } else {
                            // Vertical: "Filter by Price" centrado
                            VStack(spacing: 4) {
                                Text("Filter by Price")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .center) // Centrar horizontalmente
                                
                                HStack {
                                    Text("$\(Int(minPrice))")
                                    Slider(value: $minPrice, in: 0...viewModel.maxPriceLimit, step: 5)
                                        .onChange(of: minPrice) { newValue in
                                            viewModel.filterCards(minPrice: newValue)
                                        }
                                    Text("Max: $\(Int(viewModel.maxPriceLimit))")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    ScrollView {
                        // Ajustar columnas según la orientación
                        let columns = Array(
                            repeating: GridItem(.flexible(), spacing: 10),
                            count: isLandscape ? 4 : 3 // 4 columnas en horizontal, 3 en vertical
                        )

                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.displayedCards, id: \.id) { card in
                                NavigationLink(destination: CardDetailView(card: card)) {
                                    VStack {
                                        if let url = URL(string: card.images.large) {
                                            RemoteImage(url: url)
                                                .frame(width: 100, height: 140)
                                                .cornerRadius(8)
                                        }
                                        Text("$\(card.cardmarket?.prices.trendPrice ?? 0, specifier: "%.2f")")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .padding()
                    }

                    HStack {
                        Button(action: {
                            viewModel.previousPage()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(viewModel.currentPage > 1 ? .blue : .gray)
                                .padding(8)
                        }
                        .disabled(viewModel.currentPage == 1)

                        Text("Page \(viewModel.currentPage) of \(viewModel.totalPages)")
                            .font(.footnote)
                            .padding(.horizontal)

                        Button(action: {
                            viewModel.nextPage()
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .foregroundColor(viewModel.currentPage < viewModel.totalPages ? .blue : .gray)
                                .padding(8)
                        }
                        .disabled(viewModel.currentPage == viewModel.totalPages)
                    }
                    .padding(.bottom)
                }
                .onAppear {
                    if viewModel.filteredCards.isEmpty {
                        viewModel.loadCards() // Cargar cartas al inicio si aún no se han cargado
                    }
                }
                .alert(item: $viewModel.error) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}
