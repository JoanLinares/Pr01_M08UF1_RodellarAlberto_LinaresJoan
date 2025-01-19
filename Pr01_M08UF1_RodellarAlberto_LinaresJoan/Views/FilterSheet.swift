import SwiftUI

struct FilterSheet: View {
    @Binding var selectedType: String?
    @Binding var showFilterSheet: Bool // Variable para controlar la visibilidad del sheet
    @ObservedObject var viewModel: CardListViewModel
    
    // Definir las columnas usando el constructor Array(repeating:count:)
    let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 2
    )
    
    var body: some View {
        NavigationView {
            VStack {
                // Verificar si los tipos están cargados
                if viewModel.types.isEmpty {
                    ProgressView("Loading types...")
                        .padding()
                } else {
                    // ScrollView con LazyVGrid para las imágenes
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.types, id: \.self) { type in
                                Button(action: {
                                    if selectedType == type {
                                        selectedType = nil
                                        viewModel.filteredCards = viewModel.cards // Restablecer todas las cartas
                                    } else {
                                        selectedType = type
                                        viewModel.filterCards(by: type.lowercased()) // Filtrar por tipo
                                    }
                                }) {
                                    VStack {
                                        /*
                                         Image(type.lowercased())
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                         */
                                        Text(type)
                                            .lineLimit(1)
                                            .padding()
                                            .foregroundColor(selectedType == type ? .white : .black) // Cambiar color según si está seleccionado
                                            .frame(maxWidth: .infinity) // Hacer que todos los botones tengan el mismo ancho
                                    }
                                    .padding()
                                    .background(selectedType == type ? Color.blue : Color(.systemGray6)) // Fondo azul si seleccionado
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Filter by Type")
            .navigationBarTitleDisplayMode(.inline)  // Asegurar que el título se muestre en línea
            .padding(.top)  // Añadir espacio debajo del título
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        showFilterSheet = false // Cerrar el sheet al pulsar "Close"
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchAllTypes() // Cargar los tipos al abrir la hoja
        }
    }
}
