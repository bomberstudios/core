# Emulate Photoshop's native color schemes

$(document).on 'click', '.js-color-switcher-color', (event) ->
  event.preventDefault()
  $(this).closest('.js-color-switcher').find('.js-color-switcher-color').removeClass 'is-selected'
  $(this).addClass 'is-selected'

  window.guideguide.updateTheme $(this).attr 'data-theme-name'

  $('body').attr 'class', $(this).attr 'data-theme-name'

$(document).on 'mousedown', '.js-document', (event) ->
  event.originalEvent.preventDefault()
  return unless $(event.target).hasClass 'js-artboard'

  $('.js-document').find('.js-selection').remove()

  doc =
    top:    $('.js-document').offset().top
    left:   $('.js-document').offset().left

  artboard = 
    top:    $('.js-artboard').offset().top
    left:   $('.js-artboard').offset().left
    width:  $('.js-artboard').width()
    height: $('.js-artboard').height()

  selection =
    anchorTop:    event.pageY
    anchorLeft:   event.pageX

  css =
    top:  selection.top - doc.top
    left: selection.left - doc.top

  $selection = $('.js-templates').find('.js-selection').clone().css(css)
  $('.js-document').append($selection)


  $(document).on 'mousemove', '.js-document', (event) ->
    selection.left   = if event.pageX >= selection.anchorLeft then selection.anchorLeft else event.pageX
    selection.left   = artboard.left - 1 if selection.left < artboard.left
    selection.left   = selection.left if selection.left > selection.left
    selection.top    = if event.pageY >= selection.anchorTop then selection.anchorTop else event.pageY
    selection.top    = artboard.top - 1 if selection.top < artboard.top
    selection.top    = selection.anchorTop if selection.top > selection.anchorTop

    selection.width  = event.pageX - selection.anchorLeft
    selection.width  = artboard.left - selection.anchorLeft if event.pageX < artboard.left
    selection.width  = artboard.width - Math.abs (selection.left-artboard.left) + 1 if event.pageX > (artboard.left + artboard.width)

    selection.height = event.pageY - selection.anchorTop
    selection.height = artboard.top - selection.anchorTop if event.pageY < artboard.top
    selection.height = artboard.height - Math.abs (selection.top-artboard.top) + 1 if event.pageY > (artboard.top + artboard.height)

    css = 
      left:   selection.left - doc.left
      width:  Math.abs selection.width
      top:    selection.top - doc.top
      height: Math.abs selection.height

    $selection.css(css)

  $(document).on 'mouseup', (event) ->
    $('.js-document').find('.js-selection').remove() if $('.js-selection').width() <= 1 and $('.js-selection').height() <= 1
    $(document).off 'mousemove'
    $(document).off 'mouseup'

$ ->
  $(".js-panel").draggable({ handle: ".js-panel-handle" }).resizable({ handles: "n, e, s, w, ne, se, sw, nw" })
  $(".js-document").draggable({ handle: ".js-document-handle" }).resizable({ handles: "n, e, s, w, ne, se, sw, nw" })

  $(document).delegate '.js-guide.horizontal', 'mousedown', (event) ->
    $(this).draggable({ axis: "y", stop: => $(this).draggable("destroy") })

  $(document).delegate '.js-guide.vertical', 'mousedown', (event) ->
    $(this).draggable({ axis: "x", stop: => $(this).draggable("destroy") })
