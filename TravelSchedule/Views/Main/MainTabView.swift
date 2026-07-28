import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @Environment(\.colorScheme) private var colorScheme
    
 
    private var activeTintColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MainView()
            }
            .tabItem {
                if selectedTab == 0 {
                    Image(.arrowUpMessageBarBlack)
                        .renderingMode(.template)
                } else {
                    Image(.arrowUpMessageBarGray)
                        .renderingMode(.original)
                }
            }
            .tag(0)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                if selectedTab == 1 {
                    Image(.settingsBarBlack)
                        .renderingMode(.template)
                } else {
                    Image(.settingsBarGray)
                        .renderingMode(.original)
                }
            }
            .tag(1)
        }
        .tint(activeTintColor)
    }
}

#Preview {
    MainTabView()
}
