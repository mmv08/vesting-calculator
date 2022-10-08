let getCurrentDateISO = () =>
  Js.Date.make() |> Js.Date.toISOString |> Js.String2.substring(~from=0, ~to_=10)

let secondsBetweenDates = (date1, date2) =>
  (Js.Date.getTime(date2) -. Js.Date.getTime(date1)) /. 1000.0
