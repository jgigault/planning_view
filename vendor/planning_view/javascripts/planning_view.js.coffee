#START DOCUMENT READY
#
#
$(document).ready ->

#do stuff only on planning views
  if $('.pa-planning--container').length

#START BUDGETS SPECIFIC FILTERS
#
#
#  checkboxes for status and priority
#  (see partial '_planning_filters.html.erb')
#$(document).on 'change', "input[type='checkbox'][id='status'], input[type='checkbox'][id='priority']", () ->
#  unchecked_status = []
#  unchecked_priority = []
#  $("input[type='checkbox'][id='status']:not(:checked)").each () ->
#    unchecked_status.push $(this).val()
#  $("input[type='checkbox'][id='priority']:not(:checked)").each () ->
#    unchecked_priority.push $(this).val()
#  $('.pa-planning--row').each () ->
#    el = $(this);
#    status = el.data 'status-id'
#    priority = el.data 'priority'
#    if $.inArray(String(priority), unchecked_priority) == -1  && $.inArray(String(status), unchecked_status) == -1
#      el.show()
#    else
#      el.hide()
#
#  all/none buttons
#$(document).on 'click', '.filter-link', (e) ->
#  e.preventDefault()
#  el = $(this)
#  $("input[type='checkbox'][name='" + el.data('target') + "']").prop 'checked', (el.data('action') == 'all')
#  $("input[type='checkbox'][name='" + el.data('target') + "']").change()
#
#
#END BUDGETS SPECIFIC FILTERS

#START INTERACTIVE
#
#
#  enable/disable keyboard shortcuts 'left' and 'right'
    $(document).bind 'keydown', pa_planning_shortcuts
    $(document).bind 'keyup', pa_planning_shortcuts_unlock

    #  disable shortcuts when focusing on text inputs
    $(document).on 'focus', 'input[type=text]', () ->
      $(document).unbind 'keydown', planning_shortcuts
    $(document).on 'blur', 'input[type=text]', () ->
      $(document).bind 'keydown', planning_shortcuts

    #  control buttons
    $(document).on 'click', '.pa-planning--ctrl-move-left', (e) ->
      e.preventDefault()
      pa_planning_horizontal_move 10
    $(document).on 'click', '.pa-planning--ctrl-move-right', (e) ->
      e.preventDefault()
      pa_planning_horizontal_move(-10);
    $(document).on 'click', '.pa-planning--ctrl-move-zoom', (e) ->
      e.preventDefault()
      pa_planning_zoom $(this).data('zoom')

    #  expandable rows
    $('.pa-planning--row-expandable .pa-planning--row-container').on 'click', (e) ->
      $(this).parent().toggleClass 'open'
    #
    #
    #END INTERACTIVE

    #START INITIALIZATION
    #
    #
    #  initialize global variables
    window.pa_planning_y_limit = $('.pa-planning--container').offset().top - 79

    #  default zoom
    pa_planning_zoom $(".pa-planning--header--control-zoom li.active a").data('zoom')

    #  bind scroll to update header position
    $(window).bind 'scroll', pa_planning_update_header
    pa_planning_update_header()
#
#
#END INITIALIZATION

#
#
#END DOCUMENT READY

#START GLOBAL VARIABLES
#
#
window.pa_planning_y_limit = 0         #vertical scroll position for the floating header
window.pa_planning_ctrl_locker = false #keydown status to prevent from repeating control key
#
#
#END GLOBAL VARIABLES

#START UTILITY FUNCTION
#
#
#  update header's position
pa_planning_update_header = (e) ->
  y = $(window).scrollTop()
  if y > window.pa_planning_y_limit
    if !$('.pa-planning--header').hasClass 'pa-planning--header--fixed'
      $('.pa-planning--header').addClass 'pa-planning--header--fixed'
      $('.pa-planning--body').addClass 'pa-planning--body--alone'
  else
    if $('.pa-planning--header').hasClass 'pa-planning--header--fixed'
      $('.pa-planning--header').removeClass 'pa-planning--header--fixed'
      $('.pa-planning--body').removeClass 'pa-planning--body--alone'

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
pa_planning_wrapper_property = (property, value = undefined) ->
  return CCSStylesheetRuleStyle 'pa-planning-cssRules', '.pa-planning--container .pa-planning--row-wrapper', property, value

#  move left or right the wrappers
pa_planning_horizontal_move = (delta) ->
  unless delta == 0
    width = parseInt(pa_planning_wrapper_property 'width')
    margin_left = parseFloat(pa_planning_wrapper_property 'margin-left') + delta;
    min_margin_left = (width) * -1 + 90;
    if margin_left >= 10
      margin_left = 10
      $('.pa-planning--ctrl-move-left').hide()
    else
      $('.pa-planning--ctrl-move-left').show()
    if margin_left <= min_margin_left
      margin_left = min_margin_left
      $('.pa-planning--ctrl-move-right').hide()
    else
      $('.pa-planning--ctrl-move-right').show()
    pa_planning_wrapper_property 'margin-left', margin_left + '%'

# zoom control
pa_planning_zoom = (zoom) ->
  dropdown = $('.pa-planning--header--control-zoom')
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
      $('.pa-planning--header--month').addClass('vertical');
    else
      $('.pa-planning--header--month').removeClass('vertical');
#
#
#END UTILITY FUNCTIONS