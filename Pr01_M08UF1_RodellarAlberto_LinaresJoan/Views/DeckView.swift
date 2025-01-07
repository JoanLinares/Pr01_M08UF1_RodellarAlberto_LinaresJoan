import SwiftUI

struct DeckView: View {
    var body: some View {
        VStack {
            Text("Deck Management")
                .font(.largeTitle)
                .bold()
                .padding()

            Text("Manage your card decks here.")
                .font(.body)
                .foregroundColor(.gray)
                .padding()

            Spacer()
        }
    }
}

// Vista preliminar
struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
    }
}
