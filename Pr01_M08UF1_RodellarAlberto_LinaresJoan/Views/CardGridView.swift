import SwiftUI

struct CardGridView: View {
    @Binding var selectedCards: [Card]
    var filteredCards: [Card]
    var isLandscape: Bool  // Recibir la variable isLandscape
    
    var body: some View {
        ScrollView {
            if filteredCards.isEmpty {
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
                    ForEach(filteredCards, id: \.id) { card in
                        // Envolvemos la celda dentro de un NavigationLink
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
                                
                                HStack {
                                    // Botón para quitar la carta
                                    Button(action: {
                                        if let index = selectedCards.firstIndex(where: { $0.id == card.id }) {
                                            selectedCards.remove(at: index)
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(selectedCards.contains(where: { $0.id == card.id }) ? .red : .gray)
                                            .font(.title)
                                    }
                                    .disabled(!selectedCards.contains(where: { $0.id == card.id }))
                                    
                                    // Botón para agregar la carta
                                    Button(action: {
                                        if selectedCards.count < 20 {
                                            let selectedCardCount = selectedCards.filter { $0.id == card.id }.count
                                            if selectedCardCount < 2 {
                                                selectedCards.append(card)
                                            }
                                        }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(
                                                selectedCards.count >= 20 || selectedCards.filter { $0.id == card.id }.count >= 2 ? .gray : .blue
                                            )
                                            .font(.title)
                                    }
                                    .disabled(selectedCards.count >= 20 || selectedCards.filter { $0.id == card.id }.count >= 2)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}
