//
//  ChatView.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/26/23.
//

import SwiftUI
import Cocoa

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
	var item: Message
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
	@Binding var chatArray: Array<Message>
	
	var body: some View {
		ScrollViewReader { scrollViewProxy in
			ScrollView {
				VStack {
					ForEach(chatArray, id: \.id) { item in
						let isLastItem = item.id == chatArray[chatArray.count - 1].id
						ChatBubble(item: item, isLastItem: isLastItem)
					}
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
