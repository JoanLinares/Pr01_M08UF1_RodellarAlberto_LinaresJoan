import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Cartas Más Caras")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)

                    ForEach(viewModel.expensiveCards, id: \.id) { card in
                        HStack {
                            if let url = URL(string: card.images.large) {
                                RemoteImage(url: url)
                                    .frame(width: 100, height: 140)
                                    .cornerRadius(8)
                                    .padding(.trailing, 10)
                            }

                            VStack(alignment: .leading) {
                                Text(card.name)
                                    .font(.headline)
                                Text("Precio: $\(card.cardmarket?.prices.trendPrice ?? 0, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.loadExpensiveCards()
            }
            .navigationTitle("Cartas Pokémon")
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}
