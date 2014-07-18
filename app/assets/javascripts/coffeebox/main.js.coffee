# Coffeebox (for jQuery) version: 0.1
# @requires jQuery v1.2 or later
# @homepage https://github.com/rs-pro/coffeebox
# 
# Licensed under the MIT:
#   http://www.opensource.org/licenses/mit-license.php
# 
# Copyright (c) 2013 RocketScience.pro
# 
# Based on facebox: https://github.com/defunkt/facebox
# Copyright Forever Chris Wanstrath, Kyle Neath

$.fn.stopSpinner = ->
  $(this).each ->
    $t = $(this)
    spinner = $t.data('spinner')
    if spinner
      spinner.stop()
      $t.removeData('spinner')

$.coffeebox = (data, klass) ->
  if data.ajax
    $.coffeebox.loading data.settings or []
    fillcoffeeboxFromAjax data.ajax, klass
  else if data.image
    $.coffeebox.loading data.settings or []
    fillcoffeeboxFromImage data.image, klass
  else if data.div
    fillcoffeeboxFromHref data.div, klass
  else if $.isFunction(data)
    $.coffeebox.loading()
    data.call $
  else
    $.coffeebox.reveal data, klass

# Public, $.coffeebox methods
$.extend $.coffeebox,
  spinner:
    lines: 11 # The number of lines to draw
    length: 13 # The length of each line
    width: 4 # The line thickness
    radius: 13 # The radius of the inner circle
    corners: 1 # Corner roundness (0..1)
    color: "#000" # #rgb or #rrggbb or array of colors
    speed: 1 # Rounds per second
    trail: 89 # Afterglow percentage
    hwaccel: true # Whether to use hardware acceleration
    className: "spinner" # The CSS class to assign to the spinner

  settings:
    overlay: true
    imageTypes: ["png", "jpg", "jpeg", "gif"]
    html: """
        <div id="coffeebox" style="display:none;">
          <div class="popup">
            <div class="content"></div>
            <a class="close">&times;</a>
          </div>
        </div>
    """

  loading: ->
    init()
    return true  if $("#coffeebox .loading").length is 1
    showOverlay()
    $("#coffeebox .content").empty().append "<div class='loading'></div>"
    $(document).bind "keydown.coffeebox", (e) ->
      $.coffeebox.close()  if e.keyCode is 27
      true
    $(document).trigger "loading.coffeebox"
    $.coffeebox.align()
    setTimeout ->
      new Spinner($.coffeebox.spinner).spin($('#coffeebox .loading')[0])
    , 0
    $('#coffeebox')

  align: ->
    $("#coffeebox").show().css
      top: getPageScroll()[1] + (getPageHeight() / 10)
      left: $(window).width() / 2 - ($("#coffeebox .popup").outerWidth() / 2)

  reveal: (data, klass) ->
    if $("#coffebox .loading").length
      $("#coffebox .loading").stopSpinner()
    init()
    showOverlay()
    $(document).trigger "beforeReveal.coffeebox"
    $("#coffeebox .content").addClass klass if klass
    $("#coffeebox .content").empty().append data
    $("#coffeebox .popup").children().fadeIn "normal"
    $(document).trigger("reveal.coffeebox").trigger "afterReveal.coffeebox"
    $.coffeebox.align()
  close: ->
    $(document).trigger "close.coffeebox"
    false

# Public, $.fn methods
$.fn.coffeebox = (settings) ->
  clickHandler = ->
    $.coffeebox.loading()
    
    # support for rel="coffeebox.inline_popup" syntax, to add a class
    # also supports deprecated "coffeebox[.inline_popup]" syntax
    klass = @rel.match(/coffeebox\[?\.(\w+)\]?/)
    klass = klass[1] if klass
    fillcoffeeboxFromHref @href, klass
    false
  return init(settings) if $(this).length is 0
  @bind "click.coffeebox", clickHandler

# Private methods

# called one time to setup coffeebox on this page
init = (settings) ->
  if $('#coffeebox').length > 0
    return true
  $(document).trigger "init.coffeebox"
  imageTypes = $.coffeebox.settings.imageTypes.join("|")
  $.coffeebox.settings.imageTypesRegexp = new RegExp("\\.(" + imageTypes + ")(\\?.*)?$", "i")
  $.extend $.coffeebox.settings, settings if settings
  $("body").append $.coffeebox.settings.html
  $("#coffeebox .close").click($.coffeebox.close)

# getPageScroll() by quirksmode.com
getPageScroll = ->
  xScroll = undefined
  yScroll = undefined
  if self.pageYOffset
    yScroll = self.pageYOffset
    xScroll = self.pageXOffset
  else if document.documentElement and document.documentElement.scrollTop # Explorer 6 Strict
    yScroll = document.documentElement.scrollTop
    xScroll = document.documentElement.scrollLeft
  else if document.body # all other Explorers
    yScroll = document.body.scrollTop
    xScroll = document.body.scrollLeft
  new Array(xScroll, yScroll)

# Adapted from getPageSize() by quirksmode.com
getPageHeight = ->
  windowHeight = undefined
  if self.innerHeight # all except Explorer
    windowHeight = self.innerHeight
  else if document.documentElement and document.documentElement.clientHeight # Explorer 6 Strict Mode
    windowHeight = document.documentElement.clientHeight
  # other Explorers
  else windowHeight = document.body.clientHeight  if document.body
  windowHeight

# Figures out what you want to display and displays it
# formats are:
#     div: #id
#   image: blah.extension
#    ajax: anything else
fillcoffeeboxFromHref = (href, klass) ->
  # div
  if href.match(/#/)
    url = window.location.href.split("#")[0]
    target = href.replace(url, "")
    $.coffeebox.reveal $(target).html(), klass  if target is "#"
  
  # image
  else if href.match($.coffeebox.settings.imageTypesRegexp)
    fillcoffeeboxFromImage href, klass
  
  # ajax
  else
    fillcoffeeboxFromAjax href, klass

fillcoffeeboxFromImage = (href, klass) ->
  $.imgpreload href, (images)->
    $.coffeebox.reveal "<div class='image'><img src='#{@[0].src}' /></div>", klass

fillcoffeeboxFromAjax = (href, klass) ->
  $.coffeebox.jqxhr = $.get(href, (data) ->
    $.coffeebox.reveal data, klass
  )

skipOverlay = ->
  $.coffeebox.settings.overlay is false

hideOverlay = ->
  if skipOverlay()
    false
  else
    $("#coffeebox_overlay").addClass('hide')
    setTimeout ->
      $("#coffeebox_overlay.hide").remove()
    , 300

showOverlay = ->
  if skipOverlay()
    false
  else
    if $("#coffeebox_overlay").length is 0
      $("body").append '<div id="coffeebox_overlay" class="hide"></div>'
      $("#coffeebox_overlay").click(->
        $(document).trigger "close.coffeebox"
      )
      setTimeout ->
        $("#coffeebox_overlay").removeClass('hide')
      , 10
    else if $("#coffeebox_overlay").hasClass('hide')
      $("#coffeebox_overlay").removeClass('hide')

# Bindings
$(document).bind "close.coffeebox", ->
  if $.coffeebox.jqxhr
    $.coffeebox.jqxhr.abort()
    $.coffeebox.jqxhr = null

  $(document).unbind "keydown.coffeebox"
  $('#coffeebox').fadeOut ->
    if $("#coffebox .loading").length
      $("#coffebox .loading").stopSpinner()
    $('#coffeebox').remove()
    $(document).trigger "afterClose.coffeebox"

  hideOverlay()

# shorter alias
$.cbox = $.coffeebox
$.fn.cbox = $.fn.coffeebox

