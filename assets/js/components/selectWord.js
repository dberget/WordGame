import React, { Component } from "react"
import { GameConsumer } from "../store"

class SelectWord extends Component {
  constructor() {
    super()
    this.state = { word: "" }
  }
  render() {
    return (
      <GameConsumer>
        {({ handleWordSelect }) => (
          <div className="mb-2">
            <input
              className="rounded-sm shadow-lg h-8 mr-1"
              onChange={e => this.setState({ word: e.target.value })}
            />
            <button
              className="bg-white self-end flex-1 hover:bg-grey-lightest text-grey-darkest font-semibold py-2 px-4 border border-grey-light rounded shadow"
              onClick={() => handleWordSelect(this.state.word)}
            >
              Select Word
            </button>
          </div>
        )}
      </GameConsumer>
    )
  }
}

export default SelectWord
