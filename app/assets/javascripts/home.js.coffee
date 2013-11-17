# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $("#upload-profile").on "click", ->
    $("#upload-form").slideToggle "slow"

  $("#close1").on "click", ->
    $("#board_title").val("")
    $(".board_users_username").val("")
    $("#user-form").empty()

  $('#closeModal1').on "click", ->
    $("#board_title").val("")
    $(".board_users_username").val("")
    $("#user-form").empty()

  $("#close2").on "click", ->
    $("#modal-body2").empty()

  $('#closeModal2').on "click", ->
    $("#modal-body2").empty()

  $('#add-users').on "click", ->
    form = JST["templates/users"]
    $("#user-form").append(form)

  $('#create_board').on "click", (event) ->
    event.preventDefault()

    title = $('#board_title').val()
    users = $('.board_users_username').map (index, input) ->
      $(input).val().toLowerCase()

    if users == "" or title == ""
      alert "You have to input a title and a user to create a board!"
    else if users == gon.current_user
      alert "You can't use your own username"
    else
      params = {board: {title: title, users: users.toArray()}}

      $.post("/boards", params).done (response_data) ->
        console.log(response_data)
        # $('#user-boards').empty()
        html = JST["templates/boards"](response_data)
        $("#new-boards").prepend(html)
        $("#closeModal1").click()


  $("#wrapper").on "click", "button[data-method='delete']", (event) ->
    id = $(this).attr("data-id")
    answer = confirm ("Are you sure you want to delete this board? This is final and cannot be undone.")
    if (answer)
      $.ajax({url:"/boards/"+ id, method: "DELETE"}).done (data) ->
        board_id = "#" + id
        $(board_id).remove()

  $("#wrapper").on "click", "button[data-target='#myModal2']", (event) ->
    id = $(this).attr("data-id")
    $.getJSON("/boards/#{id}").done (response_data) ->
      update_form = JST["templates/board_update"](response_data)
      $("#modal-body2").append(update_form)


  $("#wrapper-update").on "click", "button[data-method='put']", (event) ->
    event.preventDefault()
    id = $(this).attr("data-id")
    title = $('#board_title_update').val()

    if title == ""
      alert "You have to input a title to update a board!"
    else
      $.ajax({url:"/boards/"+ id, method: "PUT", data: {board:{title: title}}}).success (data) ->
          console.log(data)
          new_title = JST["templates/board_title"](data)
          board_id = "#" + "title_" + id
          $(board_id).replaceWith(new_title)
          $("#closeModal2").click()


