timer = null
root = {id: 1, name: '', children: [], freq: 0}
data = [root]
vis = null
tir = null
diagonal = null

$(document).ready ->
  root.name = $("#tree_name").val()
  c        = $("#viewport")
  margin   = {t: 10, r: 10, b: 10, l: 10}
  tir      = d3.layout.tree().size([800, 800])
  diagonal = d3.svg.diagonal().projection((d) -> [d.y, d.x])
  vis      = d3.select("#viewport").append("svg").attr("width", 1000).attr("height", 800).append("g").attr("transform", "translate(#{margin.l},#{margin.t})")
  updateData(root)
  setInterval( reflow, 500 )

sx = (d) ->
  d.data.x0 = d.x
  d.x

sy = (d) ->
  d.data.y0 = d.y
  d.y

window.reflow = ->
  nodes = tir(root)

  link = vis.selectAll("path.link").data(
    tir.links(nodes), 
    (d) -> "#{d.source.id}-#{d.target.id}"
  )
  link.exit().remove()
  link.enter().append("svg:path").attr("class", "link").attr("d", diagonal)
  link.transition().duration(200)

  node = vis.selectAll("g.node").data(nodes, (d) -> d.data.id)
  node.exit().remove()
  g = node.enter().append("g").attr("class", "node")

  f = g.append("g").attr("class", "freq").attr("transform", (d) -> "translate(-10,0)")
  f.append("circle").attr("r", (d) -> Math.sqrt(d.data.freq))
  f.append("text").text((d) -> d.data.freq).attr('dx', 10).attr('dy', 10)
  
  g.attr("transform", (d) -> "translate(#{d.y},#{d.x})")
  g.append("circle").attr("r", 3)

  node.transition()

updateData = (parent, level = 0) =>
  return if level > 2
  return if parent.name == ''
  d3.json "/branches/#{parent.name}.json",  (d) ->
    for node in d
      node.id = data.length
      parent.children = [] unless parent.children
      parent.children.push(node)
      data.push(node)
      window.setTimeout(
        () -> updateData(node, level + 1), 
        1000
      )
      reflow()
