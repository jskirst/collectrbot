$.CB ||= {}

$.CB.Pages = 
  expand: (btn) ->
    $parent_item = $(btn).parents(".item")
    $parent_item.find(".page_group li").each ->
      $item = $(this).remove()
      console.log($item)
      $($item).insertAfter($parent_item);
    $parent_item.remove()
    
  updateGroup: (btn, action) ->
    item = $(btn).parents(".item")
    ids = $(btn).parents(".actions").data("ids")
    $.CB.Pages.postUpdates(ids, action, item)

  updatePage: (btn, action) ->
    item = $(btn).parents(".item")
    id = $(btn).parent().data("id")
    $.CB.Pages.putUpdate(id, action, item)
    
  putUpdate: (id, action, item) ->
    url = "/pages/"+id+"/"+action
    options = 
      method: "PUT"
      success: (jqXHR, data) ->
        item.slideUp()
      error: (jqXHR, resp) ->
        alert(resp)
    $.ajax(url, options)

  postUpdates: (ids, action, item) ->
    url = "/pages/"+action
    options =
      data: { ids: ids }
      method: "POST"
      success: (jqXHR, data) ->
        item.slideUp()
      error: (jqXHR, resp) ->
        alert(resp)
    $.ajax(url, options)
  
  searchOptions:
    source: "/pages/find"
    minLength: 0
    response: (e, resp) ->
      $("#search_results ul li").remove()
      items = resp.content
      if items.size == 0
        $("#search_results ul li").remove()
      else
        for item in items
          new_li = "<li><h3>"+item.title+"</h3><h5><a href='"+item.url+"'>"+item.url+"</a></h5><h6>"+item.updated_at+"</h6></li>"
          $("#search_results ul").append(new_li)
        throw "Prevent dumbass jquery UI"
