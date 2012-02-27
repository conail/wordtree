$(document).ready -> 
  $('#basic_search #term').focus()
  $('#basic_search').on 'submit', (e) ->
    e.preventDefault()
    term = $('#term', this).val()
    window.location = "/trees/#{term}"

