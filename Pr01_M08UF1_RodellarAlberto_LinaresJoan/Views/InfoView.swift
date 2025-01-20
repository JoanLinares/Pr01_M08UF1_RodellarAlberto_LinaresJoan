import SwiftUI

struct InfoView: View {
    @State private var sections = [
        SectionInfo(
            title: "App Overview",
            description: """
This app allows you to explore Pokémon cards filtered by prices and build decks using a wide selection of available cards. Dive into the world of Pokémon TCG and manage your collections efficiently!
"""
        ),
        SectionInfo(title: "Pokemon TCG API", description: "https://pokemontcg.io"),
        SectionInfo(title: "Official Pokémon Website", description: "https://www.pokemon.com"),
        SectionInfo(title: "GitHub Repository", description: "https://github.com/JoanLinares/Pr01_M08UF1_RodellarAlberto_LinaresJoan"),
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Título centrado
                Text("Information")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity) // Centramos el texto horizontalmente
                
                // Collapsible sections
                List {
                    ForEach($sections) { $section in
                        CollapsibleRow(section: $section)
                    }
                }
            }
            .navigationBarHidden(true) // Ocultar título repetido de la barra
        }
    }
}

struct CollapsibleRow: View {
    @Binding var section: SectionInfo

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(section.title)
                    .font(.headline)
                
                Spacer()
                
                // Disclosure indicator
                Image(systemName: section.isExpanded ? "chevron.down" : "chevron.right")
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    section.isExpanded.toggle()
                }
            }
            
            // Mostrar descripción y enlace al desplegar
            if section.isExpanded {
                if let url = URL(string: section.description) {
                    Link(section.description, destination: url)
                        .font(.body)
                        .foregroundColor(.blue)
                        .padding(.top, 4)
                } else {
                    Text(section.description)
                        .font(.body)
                        .padding(.top, 4)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct SectionInfo: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isExpanded: Bool = false
}
