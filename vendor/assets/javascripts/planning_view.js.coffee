#START DOCUMENT READY
#
#
$(document).ready ->

  #do stuff only on planning views
  if $('#planning-view__container').length

    #START GLOBAL VARIABLES
    #
    #
    window.pa_planning_y_limit = 0         #vertical scroll position for the floating header
    window.pa_planning_ctrl_locker = false #keydown status to prevent from repeating control key
    #
    #
    #END GLOBAL VARIABLES

    #START INTERACTIVE
    #
    #
    #  enable/disable keyboard shortcuts 'left' and 'right'
    $(document).bind 'keydown', pa_planning_shortcuts
    $(document).bind 'keyup', pa_planning_shortcuts_unlock

    #  disable shortcuts when focusing on text inputs
    $(document).on 'focus', 'input', () ->
      $(document).unbind 'keydown', planning_shortcuts
    $(document).on 'blur', 'input', () ->
      $(document).bind 'keydown', planning_shortcuts

    #  control buttons
    $(document).on 'click', '.planning-view__ctrl-move-left', (e) ->
      e.preventDefault()
      pa_planning_horizontal_move 10
    $(document).on 'click', '.planning-view__ctrl-move-right', (e) ->
      e.preventDefault()
      pa_planning_horizontal_move(-10);
    $(document).on 'click', '.planning-view__ctrl-move-zoom', (e) ->
      e.preventDefault()
      pa_planning_zoom $(this).data('zoom')

    #  expandable rows
    $('.planning-view__row-expandable .planning-view__row-container').on 'click', (e) ->
      $(this).parent().toggleClass 'open'
    #
    #
    #END INTERACTIVE

    #START INITIALIZATION
    #
    #
    #  initialize global variables
    window.pa_planning_y_limit = $('#planning-view__container').offset().top - 79

    #  default zoom
    pa_planning_zoom $(".planning-view__header--control-zoom li.active a").data('zoom')

    #  bind scroll to update header position
    $(window).bind 'scroll', pa_planning_update_header
    pa_planning_update_header()
    #
    #
    #END INITIALIZATION
#
#
#END DOCUMENT READY


#START UTILITY FUNCTION
#
#
#  update header's position
pa_planning_update_header = (e) ->
  y = $(window).scrollTop()
  if y > window.pa_planning_y_limit
    if !$('.planning-view__header').hasClass 'planning-view__header--fixed'
      $('.planning-view__header').addClass 'planning-view__header--fixed'
      $('.planning-view__body').addClass 'planning-view__body--alone'
  else
    if $('.planning-view__header').hasClass 'planning-view__header--fixed'
      $('.planning-view__header').removeClass 'planning-view__header--fixed'
      $('.planning-view__body').removeClass 'planning-view__body--alone'

#  manage keyboard shortcuts
pa_planning_shortcuts = (e) ->
  unless window.pa_planning_ctrl_locker
    if e.keyCode == 37
      #move left
      window.pa_planning_ctrl_locker = true
      pa_planning_horizontal_move 10
    else if e.keyCode == 39
      #move right
      window.pa_planning_ctrl_locker = true
      pa_planning_horizontal_move -10

#  unlock keyboard shortcuts
pa_planning_shortcuts_unlock = () ->
  window.pa_planning_ctrl_locker = false

#  access properties of the wrapper's css rule
window.CCSStylesheetRuleStyle2 = (stylesheet, selector, style, value = undefined) ->
  property = undefined
  for i in document.styleSheets
    if i.title && i.title.indexOf stylesheet != -1
      rules = i[if document.all then 'rules' else 'cssRules']
      for j in rules
        if j.selectorText == selector
          property = j.style
          break
      break
  if property == undefined
    css = "#{selector} { #{style}: #{value} }"
    console.log css
    head = document.head || document.getElementsByTagName('head')[0]
    style = document.createElement 'style'
    style.type = 'text/css'
    style.title = 'pa-planning-cssRules'
    if style.styleSheet
      style.styleSheet.cssText = css;
    else
      style.appendChild(document.createTextNode css)
    head.appendChild(style)
  else
    console.log "YES"
    if value == undefined
      return property[style]
    else
      return property[style] = value


pa_planning_wrapper_property = (property, value = undefined) ->
  return CCSStylesheetRuleStyle2 'pa-planning-cssRules', '#planning-view__container .planning-view__row-wrapper', property, value

#  move left or right the wrappers
pa_planning_horizontal_move = (delta) ->
  unless delta == 0
    width = parseInt(pa_planning_wrapper_property 'width')
    margin_left = parseFloat(pa_planning_wrapper_property 'margin-left') + delta;
    min_margin_left = (width) * -1 + 90;
    if margin_left >= 10
      margin_left = 10
      $('.planning-view__ctrl-move-left').hide()
    else
      $('.planning-view__ctrl-move-left').show()
    if margin_left <= min_margin_left
      margin_left = min_margin_left
      $('.planning-view__ctrl-move-right').hide()
    else
      $('.planning-view__ctrl-move-right').show()
    pa_planning_wrapper_property 'margin-left', margin_left + '%'

# zoom control
pa_planning_zoom = (zoom) ->
  dropdown = $('.planning-view__header--control-zoom')
  el = dropdown.find('a[data-zoom=' + zoom + ']')
  dropdown.find('li').removeClass('active')
  dropdown.find('a[data-toggle=dropdown] span').html(el.html())
  el.parent().addClass('active')
  old_width = parseFloat(pa_planning_wrapper_property 'width')
  new_width = parseFloat(el.data 'zoom')
  if old_width != new_width
    old_margin_left = parseFloat(pa_planning_wrapper_property 'margin-left')
    new_margin_left = ((old_margin_left + ((old_width - 100.0) / 2.0)) * new_width / old_width) - ((new_width - 100.0) / 2.0)
    pa_planning_wrapper_property 'width', new_width + '%'
    pa_planning_horizontal_move -(old_margin_left - new_margin_left)
    if parseInt(el.data('nb-of-months')) > 30
      $('.planning-view__header--month').addClass('vertical');
    else
      $('.planning-view__header--month').removeClass('vertical');
#
#
#END UTILITY FUNCTIONS
