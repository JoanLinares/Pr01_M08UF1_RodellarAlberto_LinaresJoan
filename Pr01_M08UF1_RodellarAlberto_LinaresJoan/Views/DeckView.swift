import SwiftUI

struct DeckView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Manage your card decks here.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()

                Spacer()
            }
            .navigationTitle("Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CardListView()) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
    }
}


// Vista preliminar
struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
    }
}
