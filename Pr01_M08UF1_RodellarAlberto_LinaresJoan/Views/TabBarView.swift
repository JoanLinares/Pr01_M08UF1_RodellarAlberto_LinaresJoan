import SwiftUI

struct MainTabBarView: View {
    var body: some View {
        TabView {
            // Pestaña central - Home Page
            MenuView()
                .tabItem {
                    Label("Home", systemImage: "house") // Ícono de casa
                }
            // Pestaña derecha - Deck
            DeckView()
                .tabItem {
                    Label("Deck", systemImage: "rectangle.stack") // Ícono de tarjetas
                }
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
