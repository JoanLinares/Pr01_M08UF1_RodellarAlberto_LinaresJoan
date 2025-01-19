import SwiftUI

struct CardListView: View {
    @StateObject private var viewModel = CardListViewModel()
    @State private var searchText = "" // Variable para almacenar el texto de búsqueda
    @State private var selectedType: String? = nil // Tipo seleccionado para filtrar
    @State private var showFilterSheet = false // Controla la visibilidad del Sheet
    
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
                                viewModel.searchCards(by: searchText) // Buscar cartas
                            }
                            .padding(.horizontal)
                        
                        // Botón de filtro
                        Button(action: {
                            showFilterSheet.toggle() // Controlar visibilidad del sheet
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle") // Ícono de filtro
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing)
                    }
                    .padding(.vertical, 10) // Ajustar padding
                    
                    // ScrollView para el contenido
                    ScrollView {
                        if viewModel.isEmptySearchResult {
                            Text("No cards found")
                                .font(.title)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
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
                                            Text("#\(card.id.split(separator: "-").last ?? ""): \(card.name)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .lineLimit(2)
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
                .sheet(isPresented: $showFilterSheet) {
                    FilterSheet(selectedType: $selectedType, showFilterSheet: $showFilterSheet, viewModel: viewModel) // Pasar la variable showFilterSheet aquí
                }
            }
        }
    }
}

// Vista preliminar
struct CardList_Preview: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
