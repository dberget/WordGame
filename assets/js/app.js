import "phoenix_html"
import ReactDOM from "react-dom"
import React from "react"
import Game from "./components/game"
import GameProvider from "./store"

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(
    <GameProvider>
      <Game />
    </GameProvider>,
    document.getElementById("game")
  )
})
