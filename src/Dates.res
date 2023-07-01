let getCurrentDateISO = () =>
  Js.Date.make() |> Js.Date.toISOString |> Js.String2.substring(~from=0, ~to_=10)

let msBetweenDates = (date1: Js.Date.t, date2: Js.Date.t) =>
  Js.Date.getTime(date2) -. Js.Date.getTime(date1)

let addYears = (date: Js.Date.t, years: float) => {
  Js.Date.setFullYear(date, Js.Date.getFullYear(date) +. years)
}

let addMonths = (date: Js.Date.t, months: float) => {
  Js.Date.setMonth(date, Js.Date.getMonth(date) +. months)
}
