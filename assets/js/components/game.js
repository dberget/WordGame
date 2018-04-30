import React, { Component } from "react"
import { GameConsumer } from "../store"
import SelectWord from "./selectWord"
import Button from "./button"
import Guess from "./guess"

const alphabet = "abcdefghijklmnopqrstuvwxyz-".split("")

const isDisabled = (guesses, letter) => {
  return guesses.some(g => g == letter)
}

class Game extends Component {
  constructor() {
    super()
  }

  render() {
    return (
      <GameConsumer>
        {({ game, handleGuess }) => (
          <div>
            {game.word.length > 0 ? (
              <div>
                <div className="font-light w-full mb-1">
                  Correct Guesses:
                  {game.correct_guesses.map(guess => <Guess guess={guess} />)}
                </div>
                <div className="text-sm font-light">
                  <span> Guess Count: </span>
                  {game.guesses.length}
                </div>
                <div className="flex justify-center">
                  {alphabet.map(letter => (
                    <Button
                      disabled={
                        game.guesses.some(g => g == letter) ||
                        game.correct_guesses.some(g => g == letter)
                      }
                      letter={letter}
                      handleClick={handleGuess}
                    />
                  ))}
                </div>
              </div>
            ) : (
              <div className="flex justify-center text-lg font-md my-2 w-1/2 m-auto">
                <SelectWord />
              </div>
            )}
            <div className="flex justify-center text-lg font-md my-2 w-full">
              {game.complete ? (
                <div>
                  <div className="my-4">Word was: {game.word}</div>
                  <div className="flex-end">
                    <SelectWord />
                  </div>
                </div>
              ) : null}
            </div>
            <div className="text-sm mb-4 w-3/5">
              Definition: {game.definition}
            </div>
          </div>
        )}
      </GameConsumer>
    )
  }
}

export default Game
