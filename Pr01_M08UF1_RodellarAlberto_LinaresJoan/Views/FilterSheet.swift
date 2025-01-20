import SwiftUI

struct FilterSheet: View {
    @Binding var selectedType: String?
    @Binding var showFilterSheet: Bool // Variable para controlar la visibilidad del sheet
    @ObservedObject var viewModel: CardListViewModel
    
    let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 2
    )
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.types.isEmpty {
                    ProgressView("Loading types...")
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.types, id: \.self) { type in
                                Button(action: {
                                    if selectedType == type {
                                        selectedType = nil
                                    } else {
                                        selectedType = type
                                    }
                                    viewModel.updateSelectedType(selectedType) // Actualizar el tipo seleccionado en el ViewModel
                                }) {
                                    VStack {
                                        Text(type)
                                            .lineLimit(1)
                                            .padding()
                                            .foregroundColor(selectedType == type ? .white : .black)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .padding()
                                    .background(selectedType == type ? Color.blue : Color(.systemGray6))
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
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        showFilterSheet = false
                    }
                }
            }
        }
    }
}
