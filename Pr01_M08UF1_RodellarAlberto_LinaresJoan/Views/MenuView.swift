import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    @State private var searchQuery = "" // Estado del buscador
    @State private var foundCard: Card? = nil // Carta encontrada
    @State private var showError = false // Mostrar "Carta no encontrada"
    @State private var selectedCard: Card? = nil // Carta seleccionada para el popup

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Sección de las cartas más caras
                VStack(alignment: .leading) {
                    Text("Cartas más caras")
                        .font(.headline)
                        .bold()
                        .padding([.top, .leading], 10)

                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), // 3 columnas
                        spacing: 10
                    ) {
                        ForEach(viewModel.expensiveCards, id: \.id) { card in
                            VStack {
                                Button(action: {
                                    selectedCard = card // Abrir popup con la carta seleccionada
                                }) {
                                    if let url = URL(string: card.images.large) {
                                        RemoteImage(url: url)
                                            .frame(width: 100, height: 140)
                                            .cornerRadius(8)
                                    }
                                }
                                Text("Price: $\(card.cardmarket?.prices.trendPrice ?? 0, specifier: "%.2f")")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2)) // Fondo gris claro
                    .cornerRadius(12)
                    .padding([.leading, .trailing])
                }

                // Buscador con botón de lupa
                VStack {
                    HStack {
                        TextField("Search by Card Number", text: $searchQuery)
                            .disabled(viewModel.allCards.isEmpty) // Deshabilitar si no hay cartas cargadas
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity) // Ajustar ancho para que quepa la lupa
                            .padding([.leading])

                        Button(action: {
                            searchCard() // Acción al presionar la lupa
                        }) {
                            Image(systemName: "magnifyingglass")
                                .padding()
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                    .padding(.horizontal)

                    if showError {
                        Text("Carta no encontrada")
                            .foregroundColor(.red)
                            .font(.caption)
                    } else if let foundCard = foundCard {
                        VStack {
                            Button(action: {
                                selectedCard = foundCard // Abrir popup con la carta encontrada
                            }) {
                                if let url = URL(string: foundCard.images.large) {
                                    RemoteImage(url: url)
                                        .frame(width: 120, height: 160)
                                        .cornerRadius(8)
                                }
                            }
                            Text("Price: $\(foundCard.cardmarket?.prices.trendPrice ?? 0, specifier: "%.2f")")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding(.top)
                    }
                }
            }
            .onAppear {
                viewModel.loadExpensiveCards()
            }
            .navigationBarHidden(true) // Ocultar barra de navegación
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
            .sheet(item: $selectedCard) { card in
                // Popup de la carta seleccionada
                CardDetailView(card: card)
            }
        }
    }

    // Función para buscar la carta
    private func searchCard() {
        // Resetear la carta encontrada para forzar redibujado
        foundCard = nil

        // Validar el número y buscar la carta
        if let card = viewModel.findCard(byNumber: searchQuery) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                foundCard = card
                showError = false
                print("Found card: \(card.name) with number \(card.number)")
            }
        } else {
            foundCard = nil
            showError = true
            print("Card not found with number: \(searchQuery)")
        }
    }
}
