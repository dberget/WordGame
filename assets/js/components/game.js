import React, { Component } from "react"
import { GameConsumer } from "../store"

class Game extends Component {
  constructor() {
    super()
  }

  render() {
    return (
      <GameConsumer>
        {({ game, handleGuess }) => (
          <div>
            <div> Last Guessed: {game.msg.content} </div>
            <button
              className="border shadow p-1 my-2"
              onClick={() => handleGuess("a")}
            >
              A
            </button>
            <button
              className="border shadow p-1 my-2"
              onClick={() => handleGuess("w")}
            >
              W
            </button>
            <button
              className="border shadow p-1 my-2"
              onClick={() => handleGuess("o")}
            >
              O
            </button>
            <button
              className="border shadow p-1 my-2"
              onClick={() => handleGuess("r")}
            >
              R
            </button>
            <button
              className="border shadow p-1 my-2"
              onClick={() => handleGuess("d")}
            >
              D
            </button>
          </div>
        )}
      </GameConsumer>
    )
  }
}

export default Game
