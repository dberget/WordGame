import React from "react"
import socket from "./socket"

const GameContext = React.createContext({})
export const GameConsumer = GameContext.Consumer

class GameProvider extends React.Component {
  constructor(props) {
    super(props)
    this.state = { slug: "", game: { word: [] } }

    this.handleGuess = this.handleGuess.bind(this)
    this.handleWordSelect = this.handleWordSelect.bind(this)
    this.getInitialGameState = this.getInitialGameState.bind(this)
  }

  componentDidMount() {
    const slug = window.location.pathname.split("/")
    let channel = socket.channel(`game: ${slug[2]}`, {})
    this.setState({ channel: channel, slug: slug[2] })
    channel.join()

    this.getInitialGameState(channel)

    channel.on("new_guess", newState => this.setState({ game: newState }))
    channel.on("new_word", newState => this.setState({ game: newState }))
  }

  getInitialGameState(channel) {
    channel
      .push("get_state")
      .receive("ok", state => this.setState({ game: state }))
  }

  handleGuess(letter) {
    this.state.channel
      .push("new_guess", { guess: letter })
      .receive("ok", msg => this.setState({ msg: msg }))
      .receive("error", msg => this.setState({ error: msg }))
  }

  handleWordSelect(word) {
    word = word.replace(/\s/g, "")

    this.state.channel
      .push("new_word", { word: word })
      .receive("ok", msg => this.setState({ word: word }))
      .receive("error", msg => this.setState({ error: msg }))
  }

  render() {
    return (
      <GameContext.Provider
        value={{
          game: this.state.game,
          handleWordSelect: this.handleWordSelect,
          handleGuess: this.handleGuess
        }}
      >
        {this.props.children}
      </GameContext.Provider>
    )
  }
}

export default GameProvider
