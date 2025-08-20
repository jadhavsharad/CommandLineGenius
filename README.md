# **🧠 CommandLineGenius**

<p align="center">
  <img alt="Swift Version" src="https://img.shields.io/badge/Swift-5.7%2B-orange"/>
  <img alt="Platform" src="https://img.shields.io/badge/Platform-macOS-lightgrey"/>
  <img alt="Contributions Welcome" src="https://img.shields.io/badge/Contributions-Welcome-brightgreen.svg"/>
  <img alt="Repo Views" src="https://komarev.com/ghpvc/?username=jadhavsharad&repo=CommandLineGenius&color=blue&style=flat&label=Views"/>
</p>

<p align="center"\>  
<strong\>Transform your natural language into executable shell commands, right in your terminal. Never forget a command again.</strong\>  
</p\>  
<p align="center">  
<video src="https://github.com/user-attachments/assets/f5aa4b31-a5c5-4632-ab3c-41c7ec028349" />
</p>

<p align="center">
<video src="https://github.com/user-attachments/assets/7b8e6978-38b6-4ff4-9f58-820eff31c327" />
</p>


## **🤔 What is CommandLineGenius?**

**CommandLineGenius** is a native macOS command-line tool that bridges the gap between human intent and machine instruction. Instead of struggling to remember the exact syntax for ```find```, ```grep```, ```awk```, or ```git``` commands, you simply describe what you want to do in plain English. The assistant uses a powerful, locally-run AI to generate the precise command and places it directly into your terminal prompt, ready for you to execute.

This project is built on the principle of **local-first AI**, ensuring your data remains private, your workflow is fast, and you have a powerful assistant even when you're offline.

## **✨ Features**

* **Natural Language to Command:** Convert complex requests like "find all files larger than 50MB in my downloads folder" into find \~/Downloads \-size \+50M.  
* **Multi-Mode Architecture:** Use flags like \--git to switch the AI's context, providing highly accurate, domain-specific commands for different tools.  
* **Seamless Shell Integration:** The generated command is injected directly into your Zsh or Bash prompt, feeling like a native feature of your terminal.  
* **100% Local & Private:** Powered by Ollama and codellama, all AI processing happens on your machine. No data ever leaves your computer.  
* **Blazingly Fast:** Built in native Swift for optimal performance on macOS.

### **Setting Up**
- Install Homebrew
- Brew Install Ollama
- Pull Codellama 7b or 13b using Ollama
- Download the tool here =>  [Download](https://github.com/jadhavsharad/CommandLineGenius/releases/download/v1.0/CommandLineGenius) 
- Copy the Provided Tool Into Below Folder
 ```
  ~/usr/local/bin/
  ```
- Integrate with shell
- Start Using CommandLineGenius
### **Integrating with Your Shell**

To enable the AI command, you need to add a small function to your shell's configuration file.

**For Zsh users (default on modern macOS):**

1. Open your Zsh configuration file: open \~/.zshrc  
2. Add the following function to the end of the file:  
   ```zsh
   # CommandLineGenius  
   AI() {  
     local cmd  
     cmd=$(CommandLineGenius "$@")  
     if [[ -n "$cmd" ]]; then  
       print -z -- "$cmd"  
     fi  
   }
   ```

3. Restart your terminal or run source \~/.zshrc. That's it\!

**For Bash users:**

1. Open your Bash configuration file: open \~/.bash\_profile  
2. Add the following function to the end of the file:  
   ```bash
   AI() {
     local cmd
     cmd=$(CommandLineGenius "$@")
     if [[ -n "$cmd" ]]; then
       READLINE_LINE="$cmd"
       READLINE_POINT=${#cmd}
     fi
   }
   ```

3. Restart your terminal or run source \~/.bash\_profile.

You're all set\! Try it out: ``` AI --git "revert the last commit" ```

## **👨‍💻 Calling All Developers\! Let's Build the Future of the Terminal.**

This project is in its early stages, and there is a massive opportunity to build something truly special for the developer community. Your contributions are not just welcome—they are essential.

### **Why Contribute?**

* **Shape a Powerful Tool:** You have the chance to influence the core functionality and direction of an exciting developer tool.  
* **Dive into Local AI:** Get hands-on experience with modern, on-device Large Language Models in a practical, real-world application.  
* **Work with Native macOS Tech:** Sharpen your Swift and command-line development skills on a project that's built for performance.

### **How You Can Help**

We have a roadmap of exciting features and improvements. Here are a few ideas to get you started:

* **🧠 Add More Modes:** The multi-mode architecture is built to be extended\! Add new modes with specialized prompts for tools like docker, kubectl, ffmpeg, or any other complex CLI.    
* **💡 Refine Prompts:** The "brain" of our assistant is the prompt. Can you refine the existing prompts to handle more complex or ambiguous user requests?  
* **🐞 Bug Squashing & Performance:** Find and fix bugs or profile the code to make it even faster and more reliable.

### **Contribution Workflow**

1. **Fork the repository** on GitHub.  
2. **Clone your fork:** git clone https://github.com/jadhavsharad/CommandLineGenius.git  
3. **Create a new branch:** git checkout \-b feature/your-awesome-feature  
4. **Make your changes** and commit them with clear, descriptive messages.  
5. **Push to your branch:** git push origin feature/your-awesome-feature  
6. **Open a Pull Request** and describe the changes you've made.

### **Developer Setup**

Ready to start hacking? Here’s how to set up your local development environment.

1. **Prerequisites:**  
   * Xcode (latest version from the Mac App Store)
   * Homebrew (For Ollama)
   * [codellama](https://ollama.com/)  (7b or 13b) Model
2. **Clone the Repository:**  
   ```zsh
   git clone https://github.com/YOUR-USERNAME/CommandLineGenius.git
   cd CommandLineGenius
   ```

3. **Set up the AI Model:**  
   This will download and set up the codellama model
   ```zsh
   brew install ollama
   ollama pull codellama:7b
   ```
   If you want to use 13b
   ```zsh
   ollama pull codellama:13b
   ```

5. **Build in Xcode:**  
   * Open the CommandLineGenius.xcodeproj file in Xcode.  
   * Ensure the "My Mac" target is selected.  
   * Build the project using **Product \> Build** (or Cmd \+ B).  
   * You can run the tool directly from Xcode to test changes.
