%%raw(`import './App.css';`)

module Vesting = {
  type vesting = Linear(string) | Exponential(string)

  let secondsInYear = 365.0 *. 24.0 *. 60.0 *. 60.0

  let linearVesting = (totalTokens, ~totalDuration=secondsInYear *. 2.0, durationElapsed) =>
    totalTokens *. durationElapsed /. secondsInYear *. 2.0

  let exponentialVesting = (totalTokens, ~totalDuration=secondsInYear *. 4.0, durationElapsed) =>
    totalTokens *.
    Js.Math.pow_float(~base=durationElapsed, ~exp=2.0) /.
    Js.Math.pow_float(~base=totalDuration, ~exp=2.0)

  let calculateVesting = (vestingType: vesting, totalTokens: float, durationElapsed: float) => {
    switch vestingType {
    | Linear => linearVesting.formula(totalTokens, durationElapsed)
    | Exponential => exponentialVesting.formula(totalTokens, durationElapsed)
    }
  }
}

@react.component
let make = () => {
  let (amount, setAmount) = React.useState(() => "0")
  let (vestingType, setVestingType) = React.useState(() => Vesting.vestings[0].label)
  let (vestingStartDate, setVestingStartDate) = React.useState(() => Js.Date.now())

  <div className="App">
    <h1> {React.string("Vesting calculator")} </h1>
    <div>
      <label htmlFor="vesting-amount-input"> {React.string("Enter vesting amount:")} </label>
      <input
        id="vesting-amount-input"
        type_="number"
        value=amount
        onChange={evt => {
          let value = ReactEvent.Form.target(evt)["value"]
          setAmount(_prev => value)
        }}
      />
    </div>
    <div>
      <label htmlFor="vesting-start-date"> {React.string("Enter vesting start date:")} </label>
      <input id="vesting-start-date" type_="date" />
    </div>
    <label htmlFor="duration-select"> {React.string("Select vesting type:")} </label>
    <select id="duration-select" defaultValue={vestingType}>
      {React.array(
        Belt.Array.map(Vesting.vestings, v => {
          <option key=v.label value=v.label onChange={_evt => setVestingType(_prev => v.label)}>
            {React.string(v.label)}
          </option>
        }),
      )}
    </select>
    <div>
      <p> {React.string(`Currently vested: ${amount}`)} </p>
    </div>
  </div>
}
