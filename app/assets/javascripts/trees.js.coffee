timer = null
root = {id: 1, name: 'of'}
data = [root]
vis = null
tree = null
diagonal = null

sx = (d) =>
  d.x0 = d.x
  d.y
sy = (d) =>
  d.y0 = d.y
  d.x

update = (branch) =>
  for node in branch
    node.id = data.length
    parent = root
    if (parent.children) then parent.children.push(node) else parent.children = [node]
    data.push(node)

    nodes = tree(root)

    node = vis.selectAll("g.node").data(nodes)
    g = node.enter().append("g").attr("class", "node").attr("transform", (d) -> "translate(#{sx},#{sy})")
    g.append("svg:circle").attr("r", 4.5)
    g.append("text").attr("dx", (d) -> if d.children then -8 else 8).attr("dy", 3).attr("text-anchor", (d) -> if d.children then "end" else "start").text((d) -> d.name).attr("cx", sx).attr("cy", sy)

    link = vis.selectAll("path.link").data(tree.links(nodes), (d) -> "#{d.source.id}-#{d.target.id}")
    
    #link.enter().insert("svg:path", "circle").attr("class", "link").attr("d", (d) ->
      #      o = {x: d.source.x0, y: d.source.y0}
      #      diagonal({source: o, target: o})
      #).attr("d", diagonal)
    link.attr("d", diagonal)

$(document).ready ->
  src    = location.pathname.match(/\w+$/)
  c      = $("#wordtree")
  margin = {t: 10, r: 10, b: 10, l: 10}
  width  =  c.width()  - margin.l - margin.r
  height =  c.height() - margin.t - margin.b
  
  tree = d3.layout.tree().size([(c.width() - margin.l - margin.r), c.height()])
  diagonal = d3.svg.diagonal().projection((d) -> [d.y, d.x])

  vis = d3.select("#wordtree").
    append("svg").
    attr("width", c.width()).
    attr("height", c.height()).
    append("g").
    attr("transform", "translate(#{margin.l},#{margin.t})")

  nodes  = tree.nodes(root)

  d3.json "/trees/#{src}.json", update
