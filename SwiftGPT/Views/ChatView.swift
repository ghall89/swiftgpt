import SwiftUI
import Cocoa

import SwiftfulLoadingIndicators

func chatColor(role: String) -> Color {
	switch role {
		case "user":
			return Color.gray
		case "assistant":
			return Color.blue
		default:
			return Color.red
	}
	
}

func shareAction(content: String) {
	let sharingPicker = NSSharingServicePicker(items: [content])
	sharingPicker.show(relativeTo: .zero, of: NSApp.keyWindow!.contentView!, preferredEdge: .maxX)
}

func copyAction(content: String) {
	let pasteboard = NSPasteboard.general
	pasteboard.declareTypes([.string], owner: nil)
	pasteboard.setString(content, forType: .string)
}

struct ChatBubble: View {
	@State private var isAnimated = false
	var item: MessageWithID
	var isLastItem: Bool
	
	var animate: Animation {
		Animation.easeOut
	}
	
	var body: some View {
		ZStack(alignment: .leading) {
			RoundedRectangle(cornerRadius: 5).foregroundColor(chatColor(role: item.role)).shadow(radius: 10)
			HStack {
				Text(item.message).padding(8).foregroundColor(.white).contextMenu(menuItems: {
					Button {
						copyAction(content: item.message)
					} label: {
						Text("Copy")
					}
					Button {
						shareAction(content: item.message)
					} label: {
						Text("Share")
					}
				})
				if item.role == "assistant" {
					Spacer()
					Button(action: {
						shareAction(content: item.message)
					}) {
						Image(systemName: "square.and.arrow.up")
					}.buttonStyle(PlainButtonStyle()).padding()
				}
			}
		}.padding([.horizontal, .top]).id(item.id).offset(x: isAnimated ? 0 : -30).opacity(isAnimated ? 1 : 0).animation(.easeOut, value: isAnimated).onAppear() {
			if isLastItem {
				isAnimated.toggle()
			}
		}
	}
}

struct ChatView: View {
	@Binding var chatArray: Array<MessageWithID>
	@Binding var loading: Bool
	
	var body: some View {
		ScrollViewReader { scrollViewProxy in
			ScrollView {
				VStack {
					if chatArray.isEmpty {
						VStack(alignment: .center) {
							Text("Enter a prompt to get started").foregroundColor(.gray).padding(30).fontWeight(.medium).font(.system(size: 20))
							
						}
					} else {
						ForEach(chatArray, id: \.id) { item in
							let isLastItem = item.id == chatArray[chatArray.count - 1].id
							ChatBubble(item: item, isLastItem: isLastItem)
						}
					}
				}
				if loading {
					LoadingIndicator(animation: .threeBallsBouncing, color: .gray, size: .small).padding()
				}
				Rectangle().frame(height: 60).foregroundColor(.clear)
			}
			.onChange(of: chatArray.count) { count in
				scrollViewProxy.scrollTo(chatArray[chatArray.count - 1].id , anchor: .bottom)
			}
		}
	}
}



//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
