options =
  source: "/pages/find"
  minLength: 0
  response: (e, resp) ->
    $("#search_results ul li").remove();
    items = resp.content
    if items.size == 0
      $("#search_results ul li").remove()
    else
      for item in items
        new_li = "<li><h3>"+item.title+"</h3><h5><a href='"+item.url+"'>"+item.url+"</a></h5><h6>"+item.updated_at+"</h6></li>"
        $("#search_results ul").append(new_li)
      throw "Prevent dumbass jquery UI"

$("#search_input").autocomplete options