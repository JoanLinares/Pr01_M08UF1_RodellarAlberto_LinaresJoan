import SwiftUI

struct CardDetailView: View {
    let card: Card

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    if let url = URL(string: card.images.large) {
                        RemoteImage(url: url)
                            .frame(
                                width: geometry.size.width > geometry.size.height ? 200 : 300, // Más pequeño en horizontal
                                height: geometry.size.width > geometry.size.height ? 280 : 420 // Proporcional en horizontal
                            )
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity) // Centrar horizontalmente
                    }

                    Text(card.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)

                    if let price = card.cardmarket?.prices.trendPrice {
                        Text("Price: $\(price, specifier: "%.2f")")
                            .font(.headline)
                    }

                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity) // Asegurar que todo el contenido esté centrado horizontalmente
                .navigationTitle(card.name) // Título jerárquico
                .navigationBarTitleDisplayMode(.inline) // Título en formato "inline"
            }
        }
    }
}
