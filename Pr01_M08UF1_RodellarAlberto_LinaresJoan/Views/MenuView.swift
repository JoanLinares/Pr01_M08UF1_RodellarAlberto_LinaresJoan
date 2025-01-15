import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    @State private var minPrice: Double = 0 // Precio mínimo

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            NavigationView {
                VStack {
                    Text("Cards")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)

                    if viewModel.maxPriceLimit > 0 {
                        VStack {
                            Text("Filter by Price")
                                .font(.headline)
                                .padding(.top)

                            HStack {
                                Text("$\(Int(minPrice))")
                                Slider(value: $minPrice, in: 0...viewModel.maxPriceLimit, step: 5)
                                    .onChange(of: minPrice) { _ in
                                        viewModel.filterCards(minPrice: minPrice)
                                    }
                                Text("Max: $\(Int(viewModel.maxPriceLimit))")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
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
                    viewModel.loadCards()
                }
                .alert(item: $viewModel.error) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}
