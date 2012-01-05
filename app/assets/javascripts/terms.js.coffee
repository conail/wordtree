$(document).ready ->
  c = $("#wordtree")
  c.empty()

  $("#toolbar form").find("input, select").change (e) ->
    $("#toolbar form").submit()

  tree = d3.layout.tree()
    .size([c.height() - 40, c.width() - 160])
    .sort((a,b) -> b.keys - a.keys)
    .separation((a, b) -> Math.sqrt((a.keys + b.keys)/2)/4)

  diagonal = d3.svg.diagonal().projection((d) -> [d.y, d.x])

  vis = d3.select("#wordtree").append("svg")
    .attr("width", c.width())
    .attr("height", c.height())
    .append("g")
    .attr("transform", "translate(100, 20)")

  d3.json "/terms.json"+location.search, (json) ->
    nodes = tree.nodes(json)

    link = vis.selectAll("path.link")
      .data(tree.links(nodes))
      .enter().append("path")
      .attr("class", "link")
      .attr("d", diagonal)

    node = vis.selectAll("g.node")
      .data(nodes)
      .enter().append("g")
      .attr("class", "node")
      .attr("transform", (d) -> "translate(#{d.y}, #{d.x})")
      .on("click", (d,i) -> 
        f = $("#toolbar form")
        f.find("input#search").val(d.name)
        f.submit()
      )

    node
      .append("circle")
      .attr("r", (d) -> Math.sqrt(d.keys))

    node
      .append("text")
        .text((d) -> d.keys)
        .attr("class", "magnitude")

    node.append("text")
      .attr("dx", (d) -> if d.children then -10 else 10)
      .attr("dy", 3)
      .attr("class", "label")
      .attr("text-anchor", (d) -> if d.children then "end" else "start")
      .attr("font-size", (d) -> Math.sqrt(d.keys)/2)
      .attr("fill-opacity", (d) -> 
        if d.keys == 0 then 0.1 else 1.1 - (1 / d.keys)
      )
      .attr("font-size", (d) -> 
        s = 2
        s = 14 - Math.floor(1 / d.keys) if d.keys > 0
        s += ""
      )
      .text((d) -> d.name)
