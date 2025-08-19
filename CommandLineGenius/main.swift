	//
	//  main.swift
	//  CommandLineGenius
	//
	//  Created by Sharad Jadhav on 19/08/25.
	//

import Foundation

	// === GET USER'S COMMANDS
var arguments = CommandLine.arguments

	// === REMOVE FIRST ARGUMENT (EXECUTABLE NAME)
arguments.removeFirst()

	// === SET DEFAULT COMMAND MODE
var mode: CommandMode = .general

	// === CHECK IF FIRST ARGUMENT IS A FLAG AND SET MODE ACCORDINGLY
if let flag = arguments.first, flag.starts(with: "--") {
	switch flag{
		case "--git":
			mode = .git
		case "--docker":
			mode = .docker
		case "--homebrew":
			mode = .homebrew
		case "--react":
			mode = .react
		case "--swift":
			mode = .swift
		case "--node":
			mode = .node
		case "--python":
			mode = .python
		case "--system":
			mode = .system
		default:
				// === HANDLE UNKNOWN FLAG ERROR
			fputs("Error: \(flag) Unknown Flag.\n", stderr)
			exit(1)
	}
		// === REMOVE FLAG ARGUMENT AFTER PROCESSING
	arguments.removeFirst()
}

	// === ENSURE USER PROVIDED A QUERY, OTHERWISE SHOW USAGE
guard !arguments.isEmpty else {
	fputs("Usage: AI [--argument] 'Your natural language query' \n", stderr)
	exit(1)
}

	// === COMBINE ALL USER INPUT ARGUMENTS INTO A SINGLE STRING
let userInput = arguments.joined(separator: " ")

	// === INITIALIZE THE OLLAMA SERVICE
let service = OllamaService()
	// === CALL THE SERVICE TO GENERATE A COMMAND FROM USER INPUT
let result = await service.generateCommand(for: userInput, mode: mode)

	// === HANDLE THE RESULT OF THE COMMAND GENERATION
switch result {
	case .success(let generatedCommand):
		
			// === PRINT GENERATED COMMAND AND EXIT SUCCESSFULLY
		print(generatedCommand)
		exit(0)
		
	case .failure(let error):
		
			// === PRINT ERROR MESSAGE IF COMMAND GENERATION FAILED
		fputs("Error: Could not generate command.\n", stderr)
		switch error {
			case .invalidURL:
					// === HANDLE MALFORMED API URL ERROR
				fputs("  Reason: The API URL inside the app is malformed. This is a developer error.\n", stderr)
			case .networkError(let underlyingError):
					// === HANDLE NETWORK FAILURE ERROR
				fputs("  Reason: Network request failed. Is the Ollama application running?\n", stderr)
				fputs("  Details: \(underlyingError.localizedDescription)\n", stderr)
			case .decodingError(let underlyingError):
					// === HANDLE DECODING ERROR FROM AI RESPONSE
				fputs("  Reason: Failed to understand the response from the AI model. The API might have changed.\n", stderr)
				fputs("  Details: \(underlyingError.localizedDescription)\n", stderr)
			case .apiError(let message):
					// === HANDLE API ERROR RETURNED BY OLLAMA
				fputs("  Reason: The Ollama API returned an error. The model might not be available.\n", stderr)
				fputs("  Details: \(message)\n", stderr)
		}
		exit(1)
}
