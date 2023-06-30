%%raw(`import './App.css';`)

@react.component
let make = () => {
  let (amount, setAmount) = React.useState(() => "0")
  let (vestingType, setVestingType) = React.useState(() => Vesting.toLabel(Linear))
  let (vestingStartDate, setVestingStartDate) = React.useState(() => Dates.getCurrentDateISO())
  let currentlyVested = Vesting.calculateVesting(
    Vesting.fromLabel(vestingType),
    float_of_string(amount),
    Dates.msBetweenDates(Js.Date.fromString(vestingStartDate), Js.Date.make()),
  )
  Js.Console.log(vestingStartDate)
  let chartData = Vesting.getChartData(
    Vesting.fromLabel(vestingType),
    Js.Date.fromString(vestingStartDate),
    float_of_string(amount),
  )

  Js.Console.log(Dates.getCurrentTimestamp())

  <div className="App">
    <h1> {React.string("Vesting calculator")} </h1>
    <div className="form-field">
      <label htmlFor="vesting-amount-input"> {React.string("Vesting amount:")} </label>
      <input
        id="vesting-amount-input"
        type_="number"
        value=amount
        onChange={evt => {
          let value = ReactEvent.Form.target(evt)["value"]
          setAmount(_prev => {
            switch value {
            | "" => "0"
            | _ => value
            }
          })
        }}
      />
    </div>
    <div className="form-field">
      <label htmlFor="vesting-start-date"> {React.string("Vesting start date:")} </label>
      <input
        id="vesting-start-date"
        type_="date"
        value=vestingStartDate
        onChange={evt => {
          let value = ReactEvent.Form.target(evt)["value"]
          setVestingStartDate(_prev => value)
        }}
      />
    </div>
    <div className="form-field">
      <label htmlFor="duration-select"> {React.string("Vesting type:")} </label>
      <select
        id="duration-select"
        defaultValue={vestingType}
        onChange={_evt => {
          let value = ReactEvent.Form.target(_evt)["value"]
          setVestingType(_prev => value)
        }}>
        {React.array(
          Belt.Array.map([Vesting.toLabel(Linear), Vesting.toLabel(Exponential)], v => {
            <option key=v value=v> {React.string(v)} </option>
          }),
        )}
      </select>
    </div>
    <div>
      <p> {React.string(`Currently vested: ${Belt.Float.toString(currentlyVested)}`)} </p>
    </div>
    <div style={ReactDOM.Style.make(~display="inline-block", ())}>
      <Chart data={chartData} />
    </div>
  </div>
}
