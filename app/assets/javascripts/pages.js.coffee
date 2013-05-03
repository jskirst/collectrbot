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

$(".expand").click ->
  $parent_item = $(this).parents(".item")
  $parent_item.find(".page_group li").each ->
    $item = $(this).remove()
    console.log($item)
    $($item).insertAfter($parent_item);
  $parent_item.remove()
  
$(".trash, .archive").click ->
  item = $(this).parents(".item")
  if $(this).hasClass("trash")
    action = "trash"
  else
    action = "archive"

  if id = $(this).parents(".actions").data("id")
    url = "/pages/"+id+"/"+action
    options = 
      method: "PUT"
      success: (jqXHR, data) ->
        item.slideUp()
      error: (jqXHR, resp) ->
        alert(resp)
  else
    ids = $(this).parents(".actions").data("ids")
    url = "/pages/"+action
    options =
      data: { ids: ids }
      method: "POST"
      success: (jqXHR, data) ->
        item.slideUp()
      error: (jqXHR, resp) ->
        alert(resp)

  $.ajax(url, options)

$(".favorite, .share").click ->
  item = $(this).parents(".item")
  if $(this).hasClass("favorite")
    action = "favorite"
  else
    action = "share"
  id = $(this).parent().data("id")
  url = "/pages/"+id+"/"+action
  options = 
    method: "PUT"
    success: (jqXHR, data) ->
      item.slideUp()
    error: (jqXHR, resp) ->
      alert(resp)
  $.ajax(url, options)