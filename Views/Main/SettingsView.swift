import SwiftUI

struct SettingsView: View {
    @State private var notificationSetting = "Standard"
    @State private var walkingSpeed = "Auto"
    @State private var selectedLanguage = "English"
    @State private var guidanceFrequency = "Standard"
    
    let guidanceOptions = [
        "Frequent": "More detailed guidance with frequent updates",
        "Standard": "Regular guidance at key decision points",
        "Minimal": "Essential guidance only at major turns"
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Notifications")) {
                    Picker("Notification Style", selection: $notificationSetting) {
                        Text("Standard").tag("Standard")
                        Text("Silent").tag("Silent")
                    }
                }
                
                Section(header: Text("Walking Speed")) {
                    Picker("Speed", selection: $walkingSpeed) {
                        Text("Slow").tag("Slow")
                        Text("Quick").tag("Quick")
                        Text("Auto").tag("Auto")
                    }
                }
                
                Section(header: Text("Language")) {
                    NavigationLink("Language Settings") {
                        Text("Language Options")
                    }
                }
                
                Section(header: Text("Sound")) {
                    NavigationLink {
                        GuidanceSettingsView(frequency: $guidanceFrequency, options: guidanceOptions)
                    } label: {
                        HStack {
                            Text("Guidance Frequency")
                            Spacer()
                            Text(guidanceFrequency)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("Help & FAQ")) {
                    NavigationLink("Premium Features") {
                        Text("Premium Features")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct GuidanceSettingsView: View {
    @Binding var frequency: String
    let options: [String: String]
    
    var body: some View {
        List {
            ForEach(Array(options.keys.sorted()), id: \.self) { option in
                VStack(alignment: .leading, spacing: 4) {
                    Button(action: {
                        frequency = option
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(option)
                                    .foregroundColor(.primary)
                                Text(options[option] ?? "")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if frequency == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Guidance Frequency")
    }
}

#Preview {
    SettingsView()
} 