//
//  generateResponse.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/25/23.
//

import Foundation

func generateText(prompt: String, key: String, engine: String, completion: @escaping (Result<String, Error>) -> Void) {
	
	let apiUrl = URL(string: "https://api.openai.com/v1/engines/\(engine)/completions")!
	var request = URLRequest(url: apiUrl)
	request.httpMethod = "POST"
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
	let parameters: [String: Any] = [
		"prompt": prompt,
		"max_tokens": 50,
		"temperature": 0.7,
		"n": 1,
		"stop": "\n"
	]
	do {
		request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
	} catch let error {
		completion(.failure(error))
		return
	}
	let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
		if let error = error {
			completion(.failure(error))
			return
		}
		guard let data = data else {
			let error = NSError(domain: "Invalid response", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from API"])
			completion(.failure(error))
			return
		}
		do {
			let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
			if let text = (jsonObject["choices"] as? [[String: Any]])?.first?["text"] as? String {
				completion(.success(text))
			} else {
				let error = NSError(domain: "Invalid response", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from API"])
				completion(.failure(error))
			}
		} catch let error {
			completion(.failure(error))
		}
	}
	task.resume()
}
