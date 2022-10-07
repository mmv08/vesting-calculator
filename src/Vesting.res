type vesting = {duration: float, formula: (float, float) => float}

let secondsInYear = 365.0 *. 24.0 *. 60.0 *. 60.0

let linearVesting = {
  duration: secondsInYear *. 2.0,
  formula: (totalTokens, durationElapsed) => totalTokens *. durationElapsed /. secondsInYear *. 2.0,
}

let exponentialVesting = {
  duration: secondsInYear *. 4.0,
  formula: (totalTokens, durationElapsed) =>
    totalTokens *.
    Js.Math.pow_float(~base=durationElapsed, ~exp=2.0) /.
    Js.Math.pow_float(~base=secondsInYear *. 4.0, ~exp=2.0),
}
