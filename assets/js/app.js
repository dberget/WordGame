import "phoenix_html"
import ReactDOM from "react-dom"
import React from "react"
import App from "./components/game"
import GameProvider from "./store"

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(
    <GameProvider>
      <App />
    </GameProvider>,
    document.getElementById("game")
  )
})
