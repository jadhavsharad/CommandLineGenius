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

	// === COMMAND MODES ENUM FOR DIFFERENT DOMAINS ===
enum CommandMode {
	case general
	case git
	case docker
	case homebrew
	case react
	case swift
	case node
	case python
	case system
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
	func generateCommand(for instruction: String, mode: CommandMode) async -> Result<String, OllamaError> {
		
			// === USING `GUARD LET` TO SAFELY CREATE URL
		guard let url = URL(string: apiUrl) else {
			return .failure(.invalidURL)
		}
		
			// === PROMPT DESIGN ===
		let prompt = getPrompt(for: instruction, mode: mode)
		
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
	
		// === FUNCTION TO BUILD PROMPT BASED ON MODE ===
	private func getPrompt(for Instruction: String, mode: CommandMode) -> String {
		let baseInstruction = "Convert the following natural language instruction into a single, executable shell command. Respond with ONLY the shell command. DO NOT ADD ANY EXPLANATIONS, MARKDOWN, BACKTICKS."
		switch mode {
			case .general:
				return """
  You are an expert command-line assistant for zsh on macOS.
  \(baseInstruction)
  
  Instruction: \(Instruction)
  """
			case .git:
				return """
  You are an expert in Git Version Control on macOS.
  \(baseInstruction) The command must be a valid 'git' command.
  
  Instruction: \(Instruction)
  """
			case .docker:
				return """
  You are a expert in Docker containerization and orchestration on macOS.
  \(baseInstruction) The command must be a valid 'docker' or 'docker-compose' command.
  
  Instruction: \(Instruction)
  """
				
			case .homebrew:
				return """
  You are a expert in Homebrew package management on macOS.
  \(baseInstruction) The command must be a valid 'brew' command.
  
  Instruction: \(Instruction)
  """
				
			case .react:
				return """
  You are a expert in React.js development and its ecosystem (npm, yarn, vite, webpack).
  \(baseInstruction) The command must be related to React project setup, building, or development.
  
  Instruction: \(Instruction)
  """
				
			case .swift:
				return """
  You are a expert in Swift and Swift Package Manager (SPM) on macOS.
  \(baseInstruction) The command must be a valid 'swift' or 'xcodebuild' command.
  
  Instruction: \(Instruction)
  """
			case .node:
				return """
 You are a expert in Node.js and JavaScript tooling on macOS.
 \(baseInstruction) The command must be a valid 'node', 'npm', 'npx', or 'yarn' command.
 
 Instruction: \(Instruction)
 """
				
			case .python:
				return """
 You are a expert in Python development and package management on macOS.
 \(baseInstruction) The command must be a valid 'python', 'pip', 'poetry', or 'venv' command.
 
 Instruction: \(Instruction)
 """
				
			case .system:
				return """
 You are a expert in macOS system administration and Unix utilities.
 \(baseInstruction) The command must be a valid macOS system command (disk, network, processes, etc.).
 
 Instruction: \(Instruction)
 """
		}
	}
}
