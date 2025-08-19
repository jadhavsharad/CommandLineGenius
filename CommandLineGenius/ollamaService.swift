	//
	//  ollamaService.swift
	//  CommandLineGenius
	//
	//  Created by Sharad Jadhav on 19/08/25.
	//

import Foundation

	// === CUSTOM OLLAMA ERROR ===
enum OllamaError: Error {
	case invalidURL
	case networkError(Error)
	case decodingError(Error)
	case apiError(String)
}

	// === OLLAMA REQUEST MODEL ===
struct OllamaRequest: Codable {
	let model: String
	let prompt: String
	var stream: Bool = false
}

	// === OLLAMA RESPONSE MODEL ===
struct OllamaResponse: Codable {
	let response: String
	let done: Bool
}


	// === OLLAMA SERVICE ===
class OllamaService {
	private let apiUrl = "http://localhost:11434/api/generate"
	private let session = URLSession.shared
	
		// === FUNCTION TO GENERATE COMMAND ===
	func generateCommand(for instruction: String) async -> Result<String, OllamaError> {
		
			// === USING `GUARD LET` TO SAFELY CREATE URL
		guard let url = URL(string: apiUrl) else {
			return .failure(.invalidURL)
		}
		
			// === PROMPT DESIGN ===
		let prompt = """
	  You are an expert command-line assistant for zsh and bash on macOS.
	  Convert the following natural language instruction into a single, executable shell command.
	  Respond with ONLY the shell command. Do not add any explanations, markdown, backticks.
	 
	  Instruction: "\(instruction)"
	 """
			// === CREATE REQUEST ===
		let requestPayload = OllamaRequest(model: "codellama", prompt: prompt)
		
			// === INITIALIZE URL REQUEST WITH TARGET URL
		var request = URLRequest(url: url)
		
			// === SET REQUEST METHOD TO POST
		request.httpMethod = "POST"
		
			// === SET REQUEST HEADER TO INDICATE JSON CONTENT
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		do {
				// === ENCODE REQUEST PAYLOAD INTO JSON BODY
			request.httpBody = try JSONEncoder().encode(requestPayload)
			
				// === SEND REQUEST AND AWAIT RESPONSE DATA
			let (data, response) = try await session.data(for: request)
			
				// === ENSURE RESPONSE IS HTTP 200 OK, OTHERWISE RETURN API ERROR
			guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
				let errorBody = String(data: data, encoding: .utf8) ?? "Unknown API error"
				return .failure(.apiError(errorBody))
			}
			
				// === DECODE SUCCESSFUL RESPONSE INTO EXPECTED TYPE
			let decodedResponse = try JSONDecoder().decode(OllamaResponse.self, from: data)
			
				// === RETURN SUCCESS WITH TRIMMED RESPONSE STRING
			return .success(decodedResponse.response.trimmingCharacters(in: .whitespacesAndNewlines))
			
		} catch let error as DecodingError {
				// === HANDLE DECODING ERROR
			return .failure(.decodingError(error))
		} catch {
				// === HANDLE NETWORK OR OTHER ERRORS
			return .failure(.networkError(error))
		}
	}
}


