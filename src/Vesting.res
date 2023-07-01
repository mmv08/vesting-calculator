type vesting = Linear | Exponential
type chartPoint = {label: string, value: float}

let linearVestingDuration = 2.0
let exponentialVestingDuration = 4.0

let linearVesting = (totalTokens, durationElapsed, totalDuration) =>
  totalTokens *. durationElapsed /. totalDuration

let exponentialVesting = (totalTokens, durationElapsed, totalDuration) => {
  totalTokens *.
  Js.Math.pow_float(~base=durationElapsed, ~exp=2.0) /.
  Js.Math.pow_float(~base=totalDuration, ~exp=2.0)
}

let calculateVesting = (
  vestingType: vesting,
  totalTokens: float,
  durationElapsed: float,
  totalDuration: float,
) => {
  let amount = switch vestingType {
  | Linear => linearVesting(totalTokens, durationElapsed, totalDuration)
  | Exponential => exponentialVesting(totalTokens, durationElapsed, totalDuration)
  }

  amount > totalTokens ? totalTokens : amount
}

let getVestingEndDate = (vestingType: vesting, startDate: Js.Date.t) => {
  switch vestingType {
  | Linear => Dates.addYears(startDate, linearVestingDuration)
  | Exponential => Dates.addYears(startDate, exponentialVestingDuration)
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

let rec getChartData = (
  ~currentlyVested=0.0,
  ~stepMonths=1.0,
  ~chartData=[],
  ~currentPoint=0.0,
  vestingType: vesting,
  startDate: Js.Date.t,
  totalTokens: float,
  totalDuration: float,
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
      totalDuration,
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

    let nextVestingPoint = vestingPoint |> Js.Date.fromFloat |> Dates.addMonths(_, stepMonths)
    getChartData(
      ~currentlyVested=vestedAtPoint,
      ~chartData=newChartData,
      ~currentPoint=nextVestingPoint,
      vestingType,
      startDate,
      totalTokens,
      totalDuration,
    )
  }
}
