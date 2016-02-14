#START DOCUMENT READY
#
#
$(document).ready ->

  #do stuff only on planning views
  if $('#planning-view__container').length

    #START GLOBAL VARIABLES
    #
    #
    window.planning_view_global_y_limit = 0         #vertical scroll position for the floating header
    window.planning_view_global_ctrl_locker = false #keydown status to prevent from repeating control key
    window.planning_view_wrapper_css_rule = undefined
    planning_view_func_initialize_wrapper_css_rule()
    #
    #
    #END GLOBAL VARIABLES

    #START INTERACTIVE
    #
    #
    #  enable/disable keyboard shortcuts 'left' and 'right'
    $(document).bind 'keydown', planning_view_func_shortcuts
    $(document).bind 'keyup',   planning_view_func_shortcuts_unlock

    #  disable shortcuts when focusing on text inputs
    $(document).on 'focus', 'input', () ->
      $(document).unbind 'keydown', planning_view_func_shortcuts
    $(document).on 'blur', 'input', () ->
      $(document).bind 'keydown', planning_view_func_shortcuts

    #  control buttons
    $(document).on 'click', '.planning-view__ctrl-move-left', (e) ->
      e.preventDefault()
      planning_view_func_move_x 10
    $(document).on 'click', '.planning-view__ctrl-move-right', (e) ->
      e.preventDefault()
      planning_view_func_move_x(-10);
    $(document).on 'click', '.planning-view__ctrl-move-zoom', (e) ->
      e.preventDefault()
      planning_view_func_zoom $(this).data('zoom')

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
    window.planning_view_global_y_limit = $('#planning-view__container').offset().top - 79

    #  default zoom
    planning_view_func_zoom $(".planning-view__header--control-zoom li.active a").data('zoom')

    #  bind scroll to update header position
    $(window).bind 'scroll', planning_view_func_update_header
    planning_view_func_update_header()
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
planning_view_func_update_header = (e) ->
  y = $(window).scrollTop()
  if y > window.planning_view_global_y_limit
    if !$('.planning-view__header').hasClass 'planning-view__header--fixed'
      $('.planning-view__header').addClass 'planning-view__header--fixed'
      $('.planning-view__body').addClass 'planning-view__body--alone'
  else
    if $('.planning-view__header').hasClass 'planning-view__header--fixed'
      $('.planning-view__header').removeClass 'planning-view__header--fixed'
      $('.planning-view__body').removeClass 'planning-view__body--alone'

#  manage keyboard shortcuts
planning_view_func_shortcuts = (e) ->
  unless window.planning_view_global_ctrl_locker
    if e.keyCode == 37
      #move left
      window.planning_view_global_ctrl_locker = true
      planning_view_func_move_x 10
    else if e.keyCode == 39
      #move right
      window.planning_view_global_ctrl_locker = true
      planning_view_func_move_x -10

#  unlock keyboard shortcuts
planning_view_func_shortcuts_unlock = () ->
  window.planning_view_global_ctrl_locker = false

#  access properties of the wrapper's css rule
planning_view_func_find_rule = (selector) ->
  for i in document.styleSheets
    rules = i[if document.all then 'rules' else 'cssRules']
    if rules
      for r in rules
        if r.selectorText == selector
          window.planning_view_wrapper_css_rule = r.style
          break


planning_view_func_initialize_wrapper_css_rule = () ->
  selector = '#planning-view__container .planning-view__row-wrapper'
  window.planning_view_wrapper_css_rule = planning_view_func_find_rule(selector)
  if window.planning_view_wrapper_css_rule == undefined
    css = "#{selector} { margin-left: 0%; #{style}: #{value} }"
    head = document.head || document.getElementsByTagName('head')[0]
    style_node = document.createElement 'style'
    style_node.type = 'text/css'
    style_node.title = 'planning-view__style'
    if style_node.styleSheet
      style_node.styleSheet.cssText = css;
    else
      style_node.appendChild(document.createTextNode css)
    head.appendChild(style_node)
    window.planning_view_wrapper_css_rule = planning_view_func_find_rule(selector)

window.planning_view_func_wrapper_property = (property, value = undefined) ->
  if value == undefined
    return window.planning_view_wrapper_css_rule[property]
  else
    return window.planning_view_wrapper_css_rule[property] = value
  #return CCSStylesheetRuleStyle2 'pa-planning-cssRules', '#planning-view__container .planning-view__row-wrapper', property, value

#  move left or right the wrappers
window.planning_view_func_move_x = (delta) ->
  unless delta == 0
    width = parseInt(planning_view_func_wrapper_property 'width')
    margin_left = parseFloat(planning_view_func_wrapper_property 'margin-left') + delta;
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
    planning_view_func_wrapper_property 'margin-left', margin_left + '%'

# zoom control
window.planning_view_func_zoom = (zoom) ->
  dropdown = $('.planning-view__header--control-zoom')
  el = dropdown.find('a[data-zoom=' + zoom + ']')
  dropdown.find('li').removeClass('active')
  dropdown.find('a[data-toggle=dropdown] span').html(el.html())
  el.parent().addClass('active')
  old_width = parseFloat(planning_view_func_wrapper_property 'width')
  new_width = parseFloat(el.data 'zoom')
  if old_width != new_width
    old_margin_left = parseFloat(planning_view_func_wrapper_property 'margin-left')
    new_margin_left = ((old_margin_left + ((old_width - 100.0) / 2.0)) * new_width / old_width) - ((new_width - 100.0) / 2.0)
    planning_view_func_wrapper_property 'width', new_width + '%'
    planning_view_func_move_x -(old_margin_left - new_margin_left)
    if parseInt(el.data('nb-of-months')) > 30
      $('.planning-view__header--month').addClass('vertical');
    else
      $('.planning-view__header--month').removeClass('vertical');
#
#
#END UTILITY FUNCTIONS
