import React from "react"

const LetterButton = ({ letter, handleClick, disabled }) => {
  return (
    <button
      disabled={disabled}
      className="rounded-sm shadow p-2 mx-1 my-2 m-auto"
      onClick={() => handleClick(letter)}
    >
      {letter}
    </button>
  )
}

export default LetterButton
