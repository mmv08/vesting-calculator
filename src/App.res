%%raw(`import './App.css';`)

@react.component
let make = () => {
  let (amount, setAmount) = React.useState(() => "0")
  let (vestingType, setVestingType) = React.useState(() => Vesting.toLabel(Exponential))
  let (vestingStartDate, setVestingStartDate) = React.useState(() => Dates.getCurrentDateISO())
  let (specificDate, setSpecificDate) = React.useState(() => "")
  let vestingEndDate = React.useMemo2(
    () =>
      Vesting.getVestingEndDate(
        Vesting.fromLabel(vestingType),
        Js.Date.fromString(vestingStartDate),
      )
      |> Js.Date.fromFloat
      |> Js.Date.toLocaleDateString,
    (vestingType, vestingStartDate),
  )
  let totalDuration = Dates.msBetweenDates(
    Js.Date.fromString(vestingStartDate),
    Js.Date.fromString(vestingEndDate),
  )
  let currentlyVested = React.useMemo4(
    () =>
      Vesting.calculateVesting(
        Vesting.fromLabel(vestingType),
        float_of_string(amount),
        Dates.msBetweenDates(Js.Date.fromString(vestingStartDate), Js.Date.make()),
        totalDuration,
      ),
    (vestingType, amount, vestingStartDate, totalDuration),
  )
  let vestedOnSpecificDate = React.useMemo5(() =>
    if Js.String2.length(specificDate) > 0 {
      Vesting.calculateVesting(
        Vesting.fromLabel(vestingType),
        float_of_string(amount),
        Dates.msBetweenDates(
          Js.Date.fromString(vestingStartDate),
          Js.Date.fromString(specificDate),
        ),
        totalDuration,
      )
    } else {
      0.
    }
  , (vestingType, amount, vestingStartDate, totalDuration, specificDate))

  let chartData = React.useMemo4(
    () =>
      Vesting.getChartData(
        Vesting.fromLabel(vestingType),
        Js.Date.fromString(vestingStartDate),
        float_of_string(amount),
        totalDuration,
      ),
    (vestingType, vestingStartDate, amount, totalDuration),
  )

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
          let year = Js.Date.getFullYear(Js.Date.fromString(value))

          // This is a pretty silly validation, but for some reason the date picker
          // Returns some weird values for the year, when the date is edited directly with the keyboard input
          if year > 2021.0 && year < 2050.0 {
            setVestingStartDate(_prev => value)
          }
        }}
      />
    </div>
    <div className="form-field">
      <label> {React.string("Vesting end date:")} </label>
      <span> {React.string(vestingEndDate)} </span>
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
    <div className="form-field">
      <label htmlFor="vesting-specific-date"> {React.string("Vested on a date:")} </label>
      <input
        id="vesting-specific-date"
        type_="date"
        value=specificDate
        onChange={evt => {
          let value = ReactEvent.Form.target(evt)["value"]
          setSpecificDate(_prev => value)
        }}
      />
    </div>
    <div className="form-field">
      <label> {React.string("Amount on a date:")} </label>
      <span> {React.float(vestedOnSpecificDate)} </span>
    </div>
    <div style={ReactDOM.Style.make(~display="inline-block", ())}>
      <Chart data={chartData} />
    </div>
    <p style={ReactDOM.Style.make(~color="red", ())}>
      <b>
        {React.string(
          "The developer of the project has never taken a math class. Please use with caution and double-check all the calculations",
        )}
      </b>
    </p>
  </div>
}
