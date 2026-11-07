module.exports =
  pkg:
    name: 'sheet', version: '0.0.1'
    # lite: 不帶 d3 的 base. 這張圖本身不用 d3; @plotdb/sheet 只有設了儲存格格式才會找 d3.format
    extend: {name: "@makechart/base", path: "lite/index.html"}
    dependencies: [
      {url: "/assets/lib/@plotdb/sheet/main/index.min.js"}
      {url: "/assets/lib/@plotdb/sheet/main/index.min.css"}
    ]
  init: ({root, context, t, pubsub}) ->
    pubsub.fire \init, mod: mod({context, t}), prepareSvg: false, layout: false

mod = ({context, t}) ->
  {chart,sheet} = context
  sample: ->
    raw: [0 to 20].map (val) ~> Object.fromEntries([1 to 5].map -> ["col#it", (Math.random! * 100).toFixed(2)])
    binding: column: [1 to 5].map -> {key: "col#it"}
  config: {}
  dimension: column: {type: \NCOR, multiple: true, name: \column}
  init: ->
    @sheet = new sheet do
      root: @root.querySelector('[plug=layout]')
      frozen: {row: 1}
      editing: false
      idx: row: true, col: true
    @data = [@binding.column.map(->it.name or it.key)] ++ @raw.map (r) ~> @binding.column.map (c) -> r[c.key]
    @sheet.data @data

  filter: (filters, internal = false) -> 
  parse: ->
    head = @binding.column.map -> it.name or it.key
    @parsed = [head] ++ (@data.map -> it.column)
    @sheet.data @parsed
  resize: ->
  render: ->
