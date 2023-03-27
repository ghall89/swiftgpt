//
//  ChatView.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/26/23.
//

import SwiftUI

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
			Text(item.message).textSelection(.enabled).padding(8).foregroundColor(.white)
		}.padding([.horizontal, .top]).id(item.id).scaleEffect(isAnimated ? 1 : 0.5).opacity(isAnimated ? 1 : 0).animation(.easeOut, value: isAnimated).onAppear() {
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
