timer = null
root = {id: 1, name: location.pathname.match(/\w+$/), children: [], freq: 0}
data = [root]
vis = null
tir = null
diagonal = null

sx = (d) ->
  d.data.x0 = d.x
  d.x

sy = (d) ->
  d.data.y0 = d.y
  d.y

linkId = (d) ->
  "#{d.source.id}-#{d.target.id}"

toggle = (d) ->
  root = d
  d3.json("/trees/#{root.data.name}.json", update)

window.reflow = ->
  nodes = tir(root)

  link = vis.selectAll("path.link").data(tir.links(nodes), linkId)
  link.enter().append("svg:path").attr("class", "link").attr("d", diagonal)

  node = vis.selectAll("g.node").data(nodes, (d) -> d.data.id)
  g = node.enter().append("g").attr("class", "node")

  f = g.append("g").attr("class", "freq").attr("transform", (d) -> "translate(-10,0)")
  f.append("circle").attr("r", (d) -> Math.sqrt(d.data.freq))
  f.append("text").text((d) -> d.data.freq).attr('dx', 10).attr('dy', 10)
  
  g.attr("transform", (d) -> "translate(#{d.y},#{d.x})")
  g.append("circle").attr("r", 3)
  g.append("text").text((d) -> d.data.name).attr('dy', 5).attr('dx', 8).on("click", toggle)



update = (parent, level = 0) =>
  return if level > 3
  d3.json "/branches/#{parent.name}.json",  (d) ->
    for node in d
      node.id = data.length
      parent.children = [] unless parent.children
      parent.children.push(node)
      data.push(node)
      update(node, level + 1)
      #reflow()



$(document).ready ->
  src      = location.pathname.match(/\w+$/)
  c        = $("#viewport")
  margin   = {t: 10, r: 10, b: 10, l: 10}
  tir      = d3.layout.tree().size([800, 400])
  diagonal = d3.svg.diagonal().projection((d) -> [d.y, d.x])
  vis      = d3.select("#viewport").append("svg").attr("width", c.width()).attr("height", c.height()).append("g").attr("transform", "translate(#{margin.l},#{margin.t})")
  update(root)
