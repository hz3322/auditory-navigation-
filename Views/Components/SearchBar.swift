import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSubmit: () -> Void = {}
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Enter destination", text: $text)
                .onSubmit(onSubmit)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
} 