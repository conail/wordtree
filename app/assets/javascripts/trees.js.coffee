timer = null
root = {id: 1, name: '', level: 0, children: [], freq: 0}
data = [root]
vis = null
tree = null
diagonal = null

currentLocation = (d) -> 
  d.data.x0 = d.x
  d.data.y0 = d.y
  "translate(#{d.y},#{d.x})"

linkLocation = (d) ->
  o = {x: d.source.data.x0, y: d.source.data.y0}
  diagonal({source: o, target: o})

$(document).ready ->
  root.name = $('#tree_name').val()
  diagonal = d3.svg.diagonal().projection((d) -> [d.y, d.x])
  vis      = d3.select('#viewport g')
  o        = $('#viewport')
  tree     = d3.layout.tree().size([o.height(), o.width() - 200])

  # Root node
  node = vis.selectAll('g.node')
    .data(tree(root))
    .enter()
    .append('g')
    .attr('class', 'node')
    .attr('transform', (d) -> "translate(#{d.y},#{d.x})")

  node.append('circle')
    .attr('class', 'marker')
    .attr('r', 5)
  node.append('text')
    .text(root.name)
    .attr('y', 5)
    .attr('x', 10)

  updateData(root)
  reflow()
  setInterval( reflow, 1000 )

window.reflow = ->
  # Recompute tree layout.
  nodes = tree(root)
  
  # NODES
  # ---------------------------------------------------------------------------
  selection = vis.selectAll('g.node')
    .data(nodes)

  # New Nodes
  enterSelection = selection.enter()
    .append('g')
    .attr('class', 'node')

  ## Frequency
  freq = enterSelection.append('circle')
    .attr('class', 'freq')
    .attr('r', (d) -> Math.sqrt(d.data.freq))
  freq = enterSelection.append('text')
    .attr('text-anchor', 'end')
    .attr('font-size', '11px')
    .attr('fill', '#444')
    .attr('y', 5).attr('x', -10)
    .text((d) -> d.data.freq)

  ## Marker
  marker = enterSelection.append('circle')
    .attr('class', 'marker')
    .attr('r', 5)
    .on('click',  (d) -> 
      d.data.children = []
      window.reflow()
    )
  
  ## Label
  label = enterSelection.append('text')
    .text((d) -> d.data.name)
    .attr('y', 5)
    .attr('x', 10)

  # Animate
  enterSelection
    .attr('transform', (d) -> "translate(#{d.parent.data.y0},#{d.parent.data.x0})")
    .transition()
    .duration(500)
    .attr('transform', currentLocation)

  selection
    .transition()
    .duration(500)
    .attr('transform', currentLocation)

  selection.exit().remove()

  # LINKS
  # ---------------------------------------------------------------------------
  link = vis.selectAll('path.link')
    .data(tree.links(nodes))

  # New Links
  link.enter()
    .insert('path', 'g.node')
    .attr('class', 'link')
    .attr('d', linkLocation)

  # All Nodes
  link
    .transition()
    .duration(500)
    .attr("d", diagonal)

  # Old Links
  link.exit().remove()

updateData = (parent) =>
  d3.json "/branches/#{parent.name}.json",  (d) ->
    if d?
      for node in d
        node.id = data.length
        node.level = parent.level + 1
        parent.children ||= [] 
        parent.children.push(node)
        data.push(node)
        if node.level < 4 and node.name not in ['', '.']
          updateData(node) 
