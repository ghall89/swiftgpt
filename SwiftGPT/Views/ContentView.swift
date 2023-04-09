import SwiftUI

struct ContentView: View {
	@State var showDialog: Bool = false
	@State var loading: Bool = false
	@State var apiKey: String = retrieveKey(key: "api_key")
	@State var prompt: String = ""
	@State var chatArray: Array = [MessageWithID]()
	
	func onStart() {
		let savedUserData = readJSON()
		for message in savedUserData {
			chatArray.append(MessageWithID(id: message.id, content: message.content, role: message.role))
		}
	}
	
	var body: some View {
		VStack(spacing: 0) {
			ChatView(chatArray: $chatArray, loading: $loading)
			Divider()
			VStack {
				HStack {
					TextField("Prompt", text: $prompt).textFieldStyle(.plain).lineLimit(1...5)
					Button(action: {
						if apiKey != "" {
							loading = true
							chatArray.append(MessageWithID(id: UUID(), content: prompt, role: "user"))
							let input = prompt
							prompt = ""
							Task {
								await handleButton(apiKey: apiKey, chatArray: &chatArray, prompt: input)
								playSound()
								loading = false
							}
						} else {
							showDialog = true
						}
					}) {
						Image(systemName: "paperplane.fill")
					} .keyboardShortcut(.defaultAction).buttonStyle(PlainButtonStyle()).foregroundColor(.blue).disabled(prompt.isEmpty).padding(.horizontal, 5)
				}.padding()
			}.padding(0)
		}.toolbar {
			ToolbarItemGroup(placement: .primaryAction) {
				Button(action: {
					showDialog = true
				}) {
					Image(systemName: "key.fill")
				}.sheet(isPresented: $showDialog) {
					DialogView(showDialog: $showDialog, apiKey: $apiKey)
				}
			}
		}.onAppear(perform: onStart)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

