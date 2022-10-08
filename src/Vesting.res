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
  let amount = switch vestingType {
  | Linear => linearVesting(totalTokens, durationElapsed)
  | Exponential => exponentialVesting(totalTokens, durationElapsed)
  }

  amount > totalTokens ? totalTokens : amount
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

let rec getChartData = (
  ~currentlyVested=0.0,
  ~step: float=secondsInMonth,
  ~chartData=[],
  ~currentPoint=0.0,
  vestingType: vesting,
  startDate: Js.Date.t,
  totalTokens: float,
): array<chartPoint> => {
  if currentlyVested == totalTokens {
    chartData
  } else {
    let vestingPoint = if currentPoint == 0.0 {
      Js.Date.getTime(startDate) /. 1000.0
    } else {
      currentPoint
    }

    let vestedAtPoint = calculateVesting(
      vestingType,
      totalTokens,
      vestingPoint -. Js.Date.getTime(startDate) /. 1000.0,
    )
    let newChartData = Belt.Array.concat(
      chartData,
      [
        {
          label: Js.Date.toLocaleDateString(Js.Date.fromFloat(vestingPoint *. 1000.0)),
          value: vestedAtPoint,
        },
      ],
    )

    getChartData(
      ~currentlyVested=vestedAtPoint,
      ~chartData=newChartData,
      ~currentPoint=vestingPoint +. step,
      vestingType,
      startDate,
      totalTokens,
    )
  }
}
