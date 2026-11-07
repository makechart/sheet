# sheet 的 test case ( @makechart/viewer 的 mctest )
mk = (rows, cols, seed = rows) ->
  rnd = mctest.random seed
  raw: [0 til rows].map -> Object.fromEntries [1 to cols].map -> ["col#it", Math.round(rnd! * 10000) / 100]
  binding: column: [1 to cols].map -> {key: "col#it"}
named = (d) ->
  d.binding.column.map (c, i) -> c.name = "欄 #{i + 1}"
  d

mctest.suite do
  size: [480, 320]
  data:
    small: mk 5, 3
    big: mk 40, 8
    named: named mk 6, 4
  cases:
    * name: "small", data: \small
    * name: "big", data: \big
    * name: "named", data: \named
    * name: "update", data: \small, steps: (c) -> d = mk 8, 5, 3; c.set-raw d.raw, d.binding
