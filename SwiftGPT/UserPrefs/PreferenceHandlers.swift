//
//  PreferenceHandlers.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/26/23.
//

import Foundation

func retrieveKey(key: String) -> String {
	let storedKey: String? = UserDefaults.standard.string(forKey: key)
	
	if storedKey != nil {
		return storedKey!
	} else {
		return ""
	}
	
}
