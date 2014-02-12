# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#datafile').change ->
    if ($('#datafile').val() != "")
      $('#submit').removeAttr('disabled')
    else
      $('#submit').attr disabled: 'disabled'
