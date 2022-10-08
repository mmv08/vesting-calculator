@react.component
let make = (~data: array<Vesting.chartPoint>) => {
  open Recharts

  <ResponsiveContainer height={Px(768.)} width={Px(1360.)}>
    <LineChart margin={"top": 0, "right": 0, "bottom": 0, "left": 0} data>
      <CartesianGrid strokeDasharray="3 3" />
      <CartesianGrid strokeDasharray="3 3" />
      <XAxis dataKey="label" />
      <YAxis width={100} />
      <Tooltip />
      <Legend />
      <Line _type=#monotone dataKey="value" stroke="#8884d8" />
    </LineChart>
  </ResponsiveContainer>
}
