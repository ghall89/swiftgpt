//
//  OpenAIHandler.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/25/23.
//

import Foundation

func generateText(prompt: String, key: String, chat: Array<Message>, completion: @escaping (Result<String, Error>) -> Void) {
	
	let apiUrl = URL(string: "https://api.openai.com/v1/engines/text-curie-001/completions")!
	var request = URLRequest(url: apiUrl)

	request.httpMethod = "POST"
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")

	let parameters: [String: Any] = [
		"prompt": prompt,
		"temperature": 0.5,
		"max_tokens": 164,
		"top_p": 1.0,
		"frequency_penalty": 0.0,
		"presence_penalty": 0.0
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
