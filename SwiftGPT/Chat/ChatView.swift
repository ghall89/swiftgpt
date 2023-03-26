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
		
		List(chatArray) { item in
			ZStack(alignment: .leading) {
				RoundedRectangle(cornerRadius: 5).foregroundColor(chatColor(role: item.role)).shadow(radius: 10)
				Text(item.message).textSelection(.enabled).padding(8).foregroundColor(.white)
			}
		}.padding(.bottom, 60)
	}
}


//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
