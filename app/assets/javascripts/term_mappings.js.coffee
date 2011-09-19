$(document).ready ->
  t =  $('.transcript').text()
  s = ''
  $.each t.split(' '), ->
    s += "<span>"+this+"</span> "
  $('.transcript').html s

  $('.transcript span').hover ->
    $(this).css('font-size', '1.2em')
  , ->
    $(this).css('font-size', '1em')
  $('.transcript span').click ->
    $('#wordtree #canvas').html($(this).text())
