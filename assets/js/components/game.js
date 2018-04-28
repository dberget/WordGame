import React, { Component } from "react"
import { GameConsumer } from "../store"
import SelectWord from "./selectWord"
import Button from "./button"
import Guess from "./guess"

const alphabet = "abcdefghijklmnopqrstuvwxyz".split("")

class Game extends Component {
  constructor() {
    super()
  }

  render() {
    return (
      <GameConsumer>
        {({ game, handleGuess }) => (
          <div>
            <div className="flex justify-center text-lg font-md my-2 w-full">
              {game.complete ? (
                <div className="">
                  Winner! Word was: {game.word.join("").toUpperCase()}
                  <div className="flex-end">
                    <SelectWord />
                  </div>
                </div>
              ) : null}
            </div>
            {game.word.length > 0 ? (
              <div className="flex">
                <div className="font-light w-full mb-1">
                  Correct Guesses:
                  {game.correct_guesses.map(guess => <Guess guess={guess} />)}
                </div>
                <div className="text-sm w-full font-light">
                  All Guesses:
                  {game.guesses.map(guess => <Guess guess={guess} />)}
                </div>
                <div className="flex w-full justify-center">
                  {alphabet.map(letter => (
                    <Button letter={letter} handleClick={handleGuess} />
                  ))}
                </div>
              </div>
            ) : (
              <div className="flex justify-center text-lg font-md my-2 w-full">
                <SelectWord />
              </div>
            )}
          </div>
        )}
      </GameConsumer>
    )
  }
}

export default Game
