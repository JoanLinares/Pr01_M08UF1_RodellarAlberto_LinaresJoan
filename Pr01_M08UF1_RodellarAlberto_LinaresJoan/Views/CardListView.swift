import SwiftUI

struct CardListView: View {
    @StateObject private var viewModel = CardListViewModel()
    @State private var searchText = "" // Variable para almacenar el texto de búsqueda
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            NavigationView {
                VStack(spacing: 0) {
                    // Barra de búsqueda (fija en la parte superior)
                    HStack {
                        TextField("Search by card name", text: $searchText)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .onChange(of: searchText) { _ in
                                viewModel.filterCards(by: searchText) // Filtrar cartas al cambiar el texto
                            }
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    .padding(.bottom, 10)

                    // ScrollView para el contenido
                    ScrollView {
                        // Mostrar mensaje de "No encontrado" si no hay resultados
                        if viewModel.isEmptySearchResult {
                            Text("No cards found")
                                .font(.title)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            // ScrollView y LazyVGrid
                            let columns = Array(
                                repeating: GridItem(.flexible(), spacing: 10),
                                count: isLandscape ? 4 : 3
                            )

                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(viewModel.filteredCards, id: \.id) { card in
                                    NavigationLink(destination: CardDetailView(card: card)) {
                                        VStack {
                                            if let url = URL(string: card.images.large) {
                                                RemoteImage(url: url)
                                                    .frame(width: 100, height: 140)
                                                    .cornerRadius(8)
                                            }
                                            Text("#\(card.id.dropFirst(4)): \(card.name)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchAllCards()
                }
                .alert(item: $viewModel.error) { error in
                    Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
                }
                .navigationBarTitle("Card List", displayMode: .inline)
            }
        }
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
