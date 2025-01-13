import SwiftUI

struct CardDetailView: View {
    let card: Card

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let url = URL(string: card.images.large) {
                    RemoteImage(url: url)
                        .frame(width: 300, height: 420)
                        .cornerRadius(12)
                }

                Text(card.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)

                if let price = card.cardmarket?.prices.trendPrice {
                    Text("Price: $\(price, specifier: "%.2f")")
                        .font(.headline)
                }

                // Puedes agregar más detalles sobre la carta aquí si es necesario
                Spacer()
            }
            .padding()
            .navigationTitle(card.name) // Título jerárquico
            .navigationBarTitleDisplayMode(.inline) // Título en formato "inline"
        }
    }
}
