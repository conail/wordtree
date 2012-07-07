timer = null
root = {id: 1, name: '', children: [], freq: 0}
data = [root]
vis = null
tree = null
diagonal = null

$(document).ready ->
  root.name = $('#tree_name').val()
  c        = $('#viewport')
  margin   = {t: 10, r: 10, b: 10, l: 10}
  tree      = d3.layout.tree().size([800, 800])
  diagonal = d3.svg.diagonal().projection((d) -> [d.y, d.x])
  vis      = d3.select('#viewport').append('svg').attr('width', 1000).attr('height', 800).append('g').attr('transform', "translate(#{margin.l},#{margin.t})")
  # Root node
  node = vis.selectAll('g.node').data(tree(root)).enter().append('g').attr('class', 'node').attr('transform', (d) -> "translate(#{d.y},#{d.x})")
  node.append('circle').attr('r', 5)
  node.append('text').text(root.name).attr('y', 5).attr('x', 10)
  updateData(root)
  reflow()
  setInterval( reflow, 1000 )

sx = (d) ->
  d.data.x0 = d.x
  d.x

sy = (d) ->
  d.data.y0 = d.y
  d.y

window.reflow = ->
  nodes = tree(root)
  
  selection = vis.selectAll('g.node').data(nodes)
  enterSelection = selection.enter().append('g').attr('class', 'node')
  enterSelection.append('circle').attr('r', 5)
  enterSelection.append('text').text((d) -> d.data.name).attr('y', 5).attr('x', 10)
  enterSelection.attr('transform', (d) -> "translate(#{d.parent.data.y0},#{d.parent.data.x0})").transition().duration(500).attr('transform', (d) -> "translate(#{sy(d)},#{sx(d)})")
  selection.transition().duration(500).attr('transform', (d) -> "translate(#{sy(d)},#{sx(d)})")

  link = vis.selectAll('path.link').data(tree.links(nodes))
  link.enter().insert('svg:path').attr('class', 'link').attr('d', (d) -> 
    o = {x: d.source.data.x0, y: d.source.data.y0}
    diagonal({source: o, target: o})
  ).transition().duration(500).attr('d', diagonal)
  link.transition().duration(500).attr("d", diagonal)

updateData = (parent, level = 0) =>
  return if parent.name == ''
  d3.json "/branches/#{parent.name}.json",  (d) ->
    for node in d
      node.id = data.length
      parent.children = [] unless parent.children
      parent.children.push(node)
      data.push(node)
      updateData(node, level + 1) if level < 4
