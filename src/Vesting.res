type vesting = Linear | Exponential
type chartPoint = {label: string, value: float}

let secondsInYear = 365.0 *. 24.0 *. 60.0 *. 60.0
let secondsInMonth = 30.0 *. 24.0 *. 60.0 *. 60.0

let linearVesting = (totalTokens, ~totalDuration=secondsInYear *. 2.0, durationElapsed) =>
  totalTokens *. durationElapsed /. totalDuration

let exponentialVesting = (totalTokens, ~totalDuration=secondsInYear *. 4.0, durationElapsed) =>
  totalTokens *.
  Js.Math.pow_float(~base=durationElapsed, ~exp=2.0) /.
  Js.Math.pow_float(~base=totalDuration, ~exp=2.0)

let calculateVesting = (vestingType: vesting, totalTokens: float, durationElapsed: float) => {
  switch vestingType {
  | Linear => linearVesting(totalTokens, durationElapsed)
  | Exponential => exponentialVesting(totalTokens, durationElapsed)
  }
}

let toLabel = (vestingType: vesting) => {
  switch vestingType {
  | Linear => "Linear"
  | Exponential => "Exponential"
  }
}

let fromLabel = (label: string) => {
  switch label {
  | "Linear" => Linear
  | "Exponential" => Exponential
  | _ => Linear
  }
}

let getChartData = (
  vestingType: vesting,
  ~step: float=secondsInMonth,
  startDate: Js.Date.t,
  ~totalDuration=secondsInYear *. 4.0,
  totalTokens: float,
) => {
  let chartData = []
  let currentPoint = ref(Js.Date.getTime(startDate) /. 1000.0)

  while currentPoint.contents < Js.Date.getTime(startDate) /. 1000.0 +. totalDuration {
    Js.Array2.push(
      chartData,
      {
        label: Js.Date.toLocaleDateString(Js.Date.fromFloat(currentPoint.contents *. 1000.0)),
        value: calculateVesting(
          vestingType,
          totalTokens,
          currentPoint.contents -. Js.Date.getTime(startDate) /. 1000.0,
        ),
      },
    )->ignore
    currentPoint := currentPoint.contents +. step
  }

  chartData
}
