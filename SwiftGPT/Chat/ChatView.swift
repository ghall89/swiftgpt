//
//  ChatView.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/26/23.
//

import SwiftUI

struct ChatView: View {
	@Binding var chatArray: Array<Message>
	
	var body: some View {
		ScrollViewReader { scrollViewProxy in
			ScrollView {
				VStack {
					ForEach(chatArray, id: \.id) { item in
						ZStack(alignment: .leading) {
							RoundedRectangle(cornerRadius: 5).foregroundColor(chatColor(role: item.role)).shadow(radius: 10)
							Text(item.message).textSelection(.enabled).padding(8).foregroundColor(.white)
						}.padding([.horizontal, .top]).id(item.id)
					}
					Rectangle().frame(height: 60).foregroundColor(.clear)
				}
				.onChange(of: chatArray.count) { count in
					scrollViewProxy.scrollTo(chatArray[chatArray.count - 1].id , anchor: .bottom)
				}
			}
		}
	}
}


//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
