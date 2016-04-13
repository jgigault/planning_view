#START DOCUMENT READY
#
#
$(document).ready ->

  #do stuff only on planning views
  if $('#PlanningViewContainer').length

    #START GLOBAL VARIABLES
    #
    #
    window.planning_view_global_y_limit = 0         #vertical scroll position for the floating header
    window.planning_view_global_ctrl_locker = false #keydown status to prevent from repeating control key
    window.planning_view_wrapper_css_rule = planning_view_func_initialize_css_rule('#PlanningViewContainer .pvc-scene__wrapper')
    window.planning_view_header_fixed_css_rule = planning_view_func_initialize_css_rule('#PlanningViewContainer .pvc-header_fixed')
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
    $(document).on 'click', '#PlanningViewContainer .pvc-control_action_move-left a', (e) ->
      e.preventDefault()
      planning_view_func_move_x 10
    $(document).on 'click', '#PlanningViewContainer .pvc-control_action_move-right a', (e) ->
      e.preventDefault()
      planning_view_func_move_x(-10);
    $(document).on 'click', '#PlanningViewContainer .pvc-control_action_zoom li a', (e) ->
      e.preventDefault()
      planning_view_func_zoom $(this).data('zoom')

    #  expandable rows
    $('#PlanningViewContainer .pvc-elem_type_expandable .pvc-scene').on 'click', (e) ->
      $(this).parent().toggleClass 'pvc-elem_expanded'
    #
    #
    #END INTERACTIVE

    #START INITIALIZATION
    #
    #
    #  initialize global variables
    window.planning_view_header_fixed_css_rule['margin-top'] = $('#PlanningViewContainer').data('header-fixed-position') + 'px'
    window.planning_view_global_y_limit = $('#PlanningViewContainer').offset().top - parseInt(window.planning_view_header_fixed_css_rule['margin-top'])

    #  default zoom
    planning_view_func_zoom $("#PlanningViewContainer .pvc-control_action_zoom li.active a").data('zoom')

    #  bind scroll to update header position
    $(window).bind 'scroll resize', planning_view_func_update_header
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
    $('#PlanningViewContainer .pvc-header').css('width', $('#PlanningViewContainer').width());
    if !$('#PlanningViewContainer .pvc-header').hasClass 'pvc-header_fixed'
      $('#PlanningViewContainer .pvc-header').addClass 'pvc-header_fixed'
      $('#PlanningViewContainer .pvc-body').addClass 'pvc-body_alone'
  else
    if $('#PlanningViewContainer .pvc-header').hasClass 'pvc-header_fixed'
      $('#PlanningViewContainer .pvc-header').removeClass 'pvc-header_fixed'
      $('#PlanningViewContainer .pvc-body').removeClass 'pvc-body_alone'

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
          return r.style
  return undefined

planning_view_func_initialize_css_rule = (selector) ->
  css_rule = planning_view_func_find_rule(selector)
  if css_rule == undefined
    css = "#{selector} { }"
    head = document.head || document.getElementsByTagName('head')[0]
    style_node = document.createElement 'style'
    style_node.type = 'text/css'
    style_node.title = 'planning-view__style'
    if style_node.styleSheet
      style_node.styleSheet.cssText = css;
    else
      style_node.appendChild(document.createTextNode css)
    head.appendChild(style_node)
    css_rule = planning_view_func_find_rule(selector)
  return css_rule

window.planning_view_func_wrapper_property = (property, value = undefined) ->
  if value == undefined
    return window.planning_view_wrapper_css_rule[property]
  else
    return window.planning_view_wrapper_css_rule[property] = value

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
  dropdown = $('#PlanningViewContainer .pvc-control_action_zoom')
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
      $('#PlanningViewContainer .pvc-header__month').addClass('pvc-header__month_vertical');
    else
      $('#PlanningViewContainer .pvc-header__month').removeClass('pvc-header__month_vertical');
#
#
#END UTILITY FUNCTIONS
