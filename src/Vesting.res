type vesting = Linear | Exponential
type chartPoint = {label: string, value: float}

let msInYear = 365.0 *. 24.0 *. 60.0 *. 60.0 *. 1000.0
let msInMonth = 30.0 *. 24.0 *. 60.0 *. 60.0 *. 1000.0

let linearVesting = (totalTokens, ~totalDuration=msInYear *. 2.0, durationElapsed) =>
  totalTokens *. durationElapsed /. totalDuration

let exponentialVesting = (totalTokens, ~totalDuration=msInYear *. 4.0, durationElapsed) =>
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
  ~step: float=msInMonth,
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
      Js.Date.getTime(startDate)
    } else {
      currentPoint
    }

    let vestedAtPoint = calculateVesting(
      vestingType,
      totalTokens,
      vestingPoint -. Js.Date.getTime(startDate),
    )
    let newChartData = Belt.Array.concat(
      chartData,
      [
        {
          label: Js.Date.toLocaleDateString(Js.Date.fromFloat(vestingPoint)),
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
