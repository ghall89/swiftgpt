//
//  DialogView.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/26/23.
//

import SwiftUI

struct DialogView: View {
	@Binding var showDialog: Bool
	@Binding var apiKey: String
	
    var body: some View {
			VStack{
				TextField("API Key", text: $apiKey)
				Button(action: {
					UserDefaults.standard.set(apiKey, forKey: "api_key")
					showDialog = false
				}) {
					Text("Ok").padding(.horizontal, 20)
				}
			}.frame(width: 300).padding()
    }
}

//struct DialogView_Previews: PreviewProvider {
//    static var previews: some View {
//        DialogView(showDialog: true, apiKey: "ABC-123")
//    }
//}
