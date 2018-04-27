import React from "react"
import socket from "./socket"

const GameContext = React.createContext({})
export const GameConsumer = GameContext.Consumer

class GameProvider extends React.Component {
  constructor(props) {
    super(props)
    this.state = { slug: "", channel: "", game: {} }

    this.handleGuess = this.handleGuess.bind(this)
  }

  componentDidMount() {
    const slug = window.location.pathname.split("/")
    let channel = socket.channel(`game: ${slug[2]}`, {})

    this.setState({ channel: channel, slug: slug[2] })

    channel.join()
  }

  handleGuess(letter) {
    console.log(letter)
    this.state.channel
      .push("new_guess", { guess: letter })
      .receive("ok", resp => {
        this.setState({ resp: resp })
      })
  }

  render() {
    return (
      <GameContext.Provider
        value={{
          game: this.state.game,
          handleGuess: this.handleGuess
        }}
      >
        {this.props.children}
      </GameContext.Provider>
    )
  }
}

export default GameProvider
