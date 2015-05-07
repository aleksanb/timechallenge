# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.datepicker').pickadate()
  $('.timepicker').pickatime(
    interval: 15
  )

  $('.chosen').chosen()

  $('[datetime]').each ->
    datetime = $(@).attr('datetime')
    $(@).html(moment(datetime).format('D MMMM, HH:mm'))
