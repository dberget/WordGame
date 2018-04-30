import React, { Component } from "react"
import { GameConsumer } from "../store"

class SelectWord extends Component {
  render() {
    return (
      <GameConsumer>
        {({ handleWordSelect }) => (
          <button
            className="bg-white self-end flex-1 hover:bg-grey-lightest text-grey-darkest font-semibold py-2 px-4 border border-grey-light rounded shadow"
            onClick={() => handleWordSelect()}
          >
            Get New Word
          </button>
        )}
      </GameConsumer>
    )
  }
}

export default SelectWord
