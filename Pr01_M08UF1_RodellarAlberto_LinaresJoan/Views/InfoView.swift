import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack {
            Text("Information Page")
                .font(.largeTitle)
                .bold()
                .padding()

            Text("Here you can find information about the app or cards.")
                .font(.body)
                .foregroundColor(.gray)
                .padding()

            Spacer()
        }
    }
}

// Vista preliminar
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
