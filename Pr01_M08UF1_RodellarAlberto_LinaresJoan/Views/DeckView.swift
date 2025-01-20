import SwiftUI

struct DeckView: View {
    @EnvironmentObject var viewModel: DeckViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.decks.isEmpty {
                    Text("No decks found")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.decks) { deck in
                            HStack {
                                if let featuredCard = deck.featuredCard, let url = URL(string: featuredCard.images.large) {
                                    RemoteImage(url: url)
                                        .frame(width: 120, height: 160)
                                        .cornerRadius(10)
                                        .padding(.trailing, 10)
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(deck.name)
                                        .font(.title)
                                    
                                    HStack {
                                        Text("Type: \(deck.type)")
                                            .font(.subheadline)
                                        
                                        Image(deck.type.lowercased())
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                    }
                                    
                                    if let featuredCard = deck.featuredCard {
                                        Text("Featured Card: \(featuredCard.name)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Text("\(deck.cards.count)/20 cards")
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                            .background(
                                NavigationLink(destination: CardListView(
                                    selectedCards: deck.cards,
                                    deckName: deck.name,
                                    selectedDeckType: deck.type,
                                    deckToEdit: deck
                                )) {
                                    EmptyView()
                                }
                                .opacity(0)
                            )
                        }
                        .onDelete { offsets in
                            for index in offsets {
                                let deck = viewModel.decks[index]
                                viewModel.deleteDeck(id: deck.id)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CardListView(
                        selectedCards: [],
                        deckName: "",
                        selectedDeckType: "",
                        deckToEdit: nil
                    )) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
    }
}
