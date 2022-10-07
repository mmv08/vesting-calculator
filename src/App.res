%%raw(`import './App.css';`)

type vestingSelectOption = {label: string, value: Vesting.vesting}

let vestingOptions = [
  {label: "Linear", value: Vesting.linearVesting},
  {label: "Exponential", value: Vesting.exponentialVesting},
]

@react.component
let make = () => {
  let (amount, setAmount) = React.useState(() => "0")
  let (vestingType, setVestingType) = React.useState(() => vestingOptions[0].label)
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
        Belt.Array.map(vestingOptions, option => {
          <option value=option.label onChange={_evt => setVestingType(_prev => option.label)}>
            {React.string(option.label)}
          </option>
        }),
      )}
    </select>
    <div> <p> {React.string("Currently vested" ++ amount)} </p> </div>
  </div>
}
