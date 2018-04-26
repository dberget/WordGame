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
      .push("new_guess", { guess: "a" })
      .receive("ok", resp => {})
  }

  render() {
    return <button onClick={this.handleGuess}>Game</button>
  }
}

export default Game
