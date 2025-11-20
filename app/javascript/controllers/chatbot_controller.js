import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "messages", "form"]

  connect() {
    this.scrollToBottom()
  }

  async send(event) {
    event.preventDefault()

    const message = this.inputTarget.value.trim()
    if (!message) return

    this.addMessage(message, "user")
    this.inputTarget.value = ""

    try {
      const response = await fetch("/web/chatbot/send_message", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({ message })
      })

      if (!response.ok) {
        throw new Error("Network response was not ok")
      }

      const data = await response.json()
      this.addMessage(data.assistant_message, "assistant")
    } catch (error) {
      console.error("Error:", error)
      this.addMessage("Sorry, I'm having trouble right now. Please try again!", "assistant")
    }
  }

  addMessage(content, role) {
    const messageDiv = document.createElement("div")
    messageDiv.className = `flex ${role === "user" ? "justify-end" : "justify-start"}`

    const bubble = document.createElement("div")
    bubble.className = role === "user"
      ? "bg-dada-primary text-white px-4 py-2 rounded-lg max-w-xs sm:max-w-md text-sm shadow"
      : "bg-gray-100 dark:bg-zinc-700 text-dada-text dark:text-white px-4 py-2 rounded-lg max-w-xs sm:max-w-md text-sm shadow"
    bubble.textContent = content

    messageDiv.appendChild(bubble)
    this.messagesTarget.appendChild(messageDiv)
    this.scrollToBottom()
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }
}
