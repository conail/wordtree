timer = null
root = {level: 0, children: [], freq: 0}
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
  root.id = parseInt($('#tree_id').val())
  root.name = $('#tree_name').val()
  diagonal = d3.svg.diagonal().projection((d) -> [d.y, d.x])
  vis      = d3.select('#viewport g')
  o        = $('#viewport')
  tree     = d3.layout.tree().size([o.height(), o.width() - 200]).sort(
    (a, b) -> 
      d3.descending(a.data.occurs, b.data.occurs) if a.data.level = 1
  ).separation((a, b) ->
    a.parent == b.parent ? 1 : 4
  )

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

  $('#suffix_visibility').change(reflow())

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
    .attr('r', (d) -> d.data.occurs)
  freq = enterSelection.append('text')
    .attr('text-anchor', 'end')
    .attr('font-size', '11px')
    .attr('fill', '#444')
    .attr('y', 5).attr('x', -10)
    .text((d) -> d.data.occurs + 1)

  ## Marker
  marker = enterSelection.append('circle')
    .attr('class', 'marker')
    .attr('r', 2)
    .on('click',  (d) -> 
      d.data.children = []
      window.reflow()
    )
  
  ## Label
  label = enterSelection.append('text')
    .text((d) -> d.data.name)
    .attr('y', 5)
    .attr('x', 10)
    .attr('font-size', (d) -> Math.max(Math.sqrt(d.data.occurs), 1) + 'em')
    .on('click', (d) -> 
      root = {level: 0, children: [], freq: 0, name: d.data.name, id: d.data.id}
      data = [root]
      updateData(root)
      reflow()
    )

  if $('#suffix_visibility').val() == 'on'
    suffix = enterSelection.append('text')
      .text((d) -> d.data.suffix)
      .attr('y', 5)
      .attr('x', 100)
      .attr('fill', '#999')

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
  d3.json "/n/#{parent.id}",  (d) ->
    if d?
      for node in d
        node.level = parent.level + 1
        node.occurs ||= 0
        parent.children ||= [] 
        parent.children.push(node)
        data.push(node)
        if node.level = 1
          updateData(node) if node.occurs > 3 and node.occurs < 1000
        else 
          updateData(node)