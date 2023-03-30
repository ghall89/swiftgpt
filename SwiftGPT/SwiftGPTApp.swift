import SwiftUI

@main
struct SwiftGPTApp: App {
		@Environment(\.openURL) private var openURL
	
    var body: some Scene {
        WindowGroup {
            ContentView()
						.frame(minWidth: 400, minHeight: 200)
				}.commands(content: {
					CommandGroup(replacing: .help) {
						Button("SwiftGPT Help") {
							if let url = URL(string: "https://github.com/ghall89/swiftgpt#readme") {
								openURL(url)
							}
						}
					}
				})
    }
}
