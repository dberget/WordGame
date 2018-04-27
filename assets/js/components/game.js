import React, { Component } from "react"
import socket from "../socket"

class Game extends Component {
  constructor() {
    super()

    this.state = {}

    this.handleGuess = this.handleGuess.bind(this)
  }

  componentDidMount() {
    const slug = window.location.pathname.split("/")
    let channel = socket.channel(`game: ${slug[2]}`, {})

    this.setState({ channel: channel, slug: slug[2] })

    channel.join()
  }

  handleGuess() {
    this.state.channel
      .push("new_guess", { guess: this.state.guess })
      .receive("ok", resp => {
        console.log(resp)
      })
  }

  render() {
    return (
      <div>
        <button
          className="border shadow p-1 my-2"
          onClick={() => this.handleGuess()}
        >
          Submit Guess
        </button>
        <input
          onChange={e => this.setState({ guess: e.target.value })}
          className="border shadow h-8 ml-1 p-1"
          type="text"
          maxLength="1"
        />
      </div>
    )
  }
}

export default Game
