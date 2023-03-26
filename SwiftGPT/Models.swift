//
//  Models.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/25/23.
//

import Foundation

struct Message: Identifiable {
	let id = UUID()
	let message: String
	let role: String
}
