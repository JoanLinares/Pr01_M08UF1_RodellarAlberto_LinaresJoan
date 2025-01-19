import SwiftUI

struct DeckView: View {
    @EnvironmentObject var viewModel: DeckViewModel // Usamos el DeckViewModel del entorno

    var body: some View {
        NavigationView {
            VStack {
                // Verificamos si hay decks
                if viewModel.decks.isEmpty {
                    Text("No decks found")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Lista que muestra todos los decks con capacidad de eliminación al deslizar
                    List {
                        ForEach(viewModel.decks) { deck in
                            HStack {
                                // Mostrar la carta destacada en tamaño grande
                                if let featuredCard = deck.featuredCard, let url = URL(string: featuredCard.images.large) {
                                    RemoteImage(url: url)
                                        .frame(width: 120, height: 160) // Imagen más grande
                                        .cornerRadius(10)
                                        .padding(.trailing, 10)
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(deck.name)
                                        .font(.headline)
                                    
                                    Text("Type: \(deck.type)")
                                        .font(.subheadline)
                                    
                                    if let featuredCard = deck.featuredCard {
                                        Text("Featured Card: \(featuredCard.name)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete { offsets in
                            // Llamamos a la función deleteDeck del ViewModel directamente
                            for index in offsets {
                                let deck = viewModel.decks[index]
                                viewModel.deleteDeck(id: deck.id) // Llamamos a deleteDeck en el VM
                            }
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CardListView()) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
    }
}
