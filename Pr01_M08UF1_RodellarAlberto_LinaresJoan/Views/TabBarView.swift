import SwiftUI

struct MainTabBarView: View {
    @StateObject var deckViewModel = DeckViewModel() // Crear la instancia del ViewModel

    var body: some View {
        TabView {
            // Pestaña central - Home Page
            MenuView()
                .tabItem {
                    Label("Home", systemImage: "house") // Ícono de casa
                }
            // Pestaña derecha - Deck
            DeckView() // No necesitas pasar el ViewModel aquí, porque DeckView lo obtendrá desde el entorno
                .tabItem {
                    Label("Decks", systemImage: "rectangle.stack") // Ícono de tarjetas
                }
                .environmentObject(deckViewModel) // Inyecta el ViewModel en el entorno
            // Pestaña izquierda - Información
            InfoView()
                .tabItem {
                    Label("Info", systemImage: "info.circle") // Ícono de información
                }
        }
    }
}

// Vista preliminar
struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
    }
}
