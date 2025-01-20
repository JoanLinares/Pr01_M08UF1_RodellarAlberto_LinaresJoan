import SwiftUI

struct CardListView: View {
    @StateObject private var viewModel = CardListViewModel()
    @EnvironmentObject var deckViewModel: DeckViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var searchText = ""
    @State private var selectedType: String? = nil
    @State private var showFilterSheet = false
    
    @State private var selectedCards: [Card] = []
    @State private var deckName: String = "" // Nombre del mazo ingresado por el usuario
    @State private var types: [String] = []  // Tipos disponibles
    @State private var selectedDeckType: String = "" // Tipo seleccionado para el mazo
    
    @State private var showSaveAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            VStack(spacing: 0) {
                // Botón de "Save"
                HStack {
                    TextField("Enter deck name", text: $deckName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Spacer()
                    Button(action: {
                        // Llamamos a la función createDeck de DeckViewModel
                        deckViewModel.createDeck(
                            name: deckName,
                            type: selectedDeckType,
                            cards: selectedCards,
                            featuredCard: selectedCards.first
                        )
                        
                        showSaveAlert = true
                    }) {
                        Text("Save")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .background(deckName.isEmpty || selectedCards.count < 1 ? Color.gray : Color.blue) // Cambiar el color de fondo según si está habilitado o no
                    .cornerRadius(8)
                    .disabled(deckName.isEmpty || selectedCards.count < 1) // Deshabilitar el botón si no se cumplen las condiciones
                }
                .padding(.trailing, 20) // Agregar espacio entre el borde derecho y el botón
                
                // Desplegable para seleccionar el tipo del mazo
                if !types.isEmpty {
                    HStack {
                        Text("Select a type of deck: ")
                            .font(.headline)
                        
                        Picker("", selection: $selectedDeckType) {
                            ForEach(types, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Estilo desplegable
                    }
                    .padding(.vertical, 10) // Espacio alrededor del Picker
                }
                
                // Texto con número de cartas seleccionadas
                if !selectedCards.isEmpty {
                    VStack(spacing: 5) {
                        Text("\(selectedCards.count)/20 cards selected")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(selectedCards.prefix(20), id: \.id) { card in
                                    if let url = URL(string: card.images.small) {
                                        RemoteImage(url: url)
                                            .frame(width: 50, height: 70)
                                            .cornerRadius(5)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
                
                // Barra de búsqueda
                HStack {
                    TextField("Search by card name or ID", text: $searchText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: searchText) { _ in
                            viewModel.searchCards(by: searchText)
                        }
                        .padding(.horizontal)
                    
                    Button(action: {
                        showFilterSheet.toggle()
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                .padding(.vertical, 10)
                
                CardGridView(selectedCards: $selectedCards, filteredCards: viewModel.filteredCards, isLandscape: isLandscape)
                    .padding(.top, 10)
            }
        }
        .navigationTitle("Create a new deck")
        .onAppear {
            viewModel.fetchAllCards()
            viewModel.fetchAllTypes()
        }
        .onReceive(viewModel.$types) { fetchedTypes in
            types = fetchedTypes
            if !fetchedTypes.isEmpty {
                selectedDeckType = fetchedTypes.first ?? ""
            }
        }
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheet(selectedType: $selectedType, showFilterSheet: $showFilterSheet, viewModel: viewModel)
        }
        .alert(isPresented: $showSaveAlert) {
            Alert(
                title: Text("Deck Saved"),
                message: Text("Your deck has been successfully saved!"),
                dismissButton: .default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }
}

