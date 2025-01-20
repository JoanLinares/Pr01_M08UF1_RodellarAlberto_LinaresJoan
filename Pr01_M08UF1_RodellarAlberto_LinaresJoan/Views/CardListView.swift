import SwiftUI

struct CardListView: View {
    @StateObject private var viewModel = CardListViewModel()
    @EnvironmentObject var deckViewModel: DeckViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var searchText = ""
    @State private var selectedType: String? = nil
    @State private var showFilterSheet = false
    
    @State private var selectedCards: [Card] = []
    @State private var deckName: String = ""
    @State private var types: [String] = []
    @State private var selectedDeckType: String = ""
    
    @State private var showSaveAlert = false
    @State private var isEditing = false
    @State private var deckToEdit: Deck? // Deck que se va a editar

    // Inicializador que recibe la información del deck
    init(selectedCards: [Card], deckName: String, selectedDeckType: String, deckToEdit: Deck?) {
        _selectedCards = State(initialValue: selectedCards)
        _deckName = State(initialValue: deckName)
        _selectedDeckType = State(initialValue: selectedDeckType)
        _deckToEdit = State(initialValue: deckToEdit)
        _isEditing = State(initialValue: deckToEdit != nil)
    }

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            VStack(spacing: 0) {
                HStack {
                    TextField("Enter deck name", text: $deckName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Spacer()
                    Button(action: {
                        if let deckToEdit = deckToEdit {
                            // Llamamos a la función updateDeck si estamos editando un deck existente
                            deckViewModel.updateDeck(
                                id: deckToEdit.id,
                                newName: deckName,
                                newType: selectedDeckType,
                                newCards: selectedCards,
                                newFeaturedCard: selectedCards.first
                            )
                        } else {
                            // Crear un nuevo deck si no estamos editando
                            deckViewModel.createDeck(
                                name: deckName,
                                type: selectedDeckType,
                                cards: selectedCards,
                                featuredCard: selectedCards.first
                            )
                        }
                        
                        showSaveAlert = true
                    }) {
                        Text(isEditing ? "Update" : "Save")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .background(deckName.isEmpty || selectedCards.count < 1 ? Color.gray : Color.blue)
                    .cornerRadius(8)
                    .disabled(deckName.isEmpty || selectedCards.count < 1)
                }
                .padding(.trailing, 20)
                
                if !types.isEmpty {
                    HStack {
                        Text("Select a type of deck: ")
                            .font(.headline)
                        
                        Picker("", selection: $selectedDeckType) {
                            ForEach(types, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.vertical, 10)
                }
                
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
        .navigationTitle(isEditing ? "Edit Deck" : "Create a new deck")
        .onAppear {
            viewModel.fetchAllCards()
            viewModel.fetchAllTypes()
        }
        .onReceive(viewModel.$types) { fetchedTypes in
            types = fetchedTypes
            if !fetchedTypes.isEmpty && selectedDeckType.isEmpty {
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
                title: Text(isEditing ? "Deck Updated" : "Deck Saved"),
                message: Text(isEditing ? "Your deck has been successfully updated!" : "Your deck has been successfully saved!"),
                dismissButton: .default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }
}
