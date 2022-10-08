@react.component
let make = (~data: array<Vesting.chartPoint>) => {
  open Recharts

  <ResponsiveContainer height="100%" width="100%">
    <LineChart margin={"top": 0, "right": 0, "bottom": 0, "left": 0} data>
      <CartesianGrid strokeDasharray="3 3" />
      <CartesianGrid strokeDasharray="3 3" />
      <XAxis dataKey="label" />
      <YAxis />
      <Tooltip />
      <Legend />
      <Line _type=#monotone dataKey="value" stroke="#8884d8" />
    </LineChart>
  </ResponsiveContainer>
}
