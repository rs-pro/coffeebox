# * Facebox (for jQuery)
# * version: 1.3
# * @requires jQuery v1.2 or later
# * @homepage https://github.com/defunkt/facebox
# *
# * Licensed under the MIT:
# *   http://www.opensource.org/licenses/mit-license.php
# *
# * Copyright Forever Chris Wanstrath, Kyle Neath
# *
# * Usage:
# *
# *  jQuery(document).ready(function() {
# *    jQuery('a[rel*=facebox]').facebox()
# *  })
# *
# *  <a href="#terms" rel="facebox">Terms</a>
# *    Loads the #terms div in the box
# *
# *  <a href="terms.html" rel="facebox">Terms</a>
# *    Loads the terms.html page in the box
# *
# *  <a href="terms.png" rel="facebox">Terms</a>
# *    Loads the terms.png image in the box
# *
# *
# *  You can also use it programmatically:
# *
# *    jQuery.facebox('some html')
# *    jQuery.facebox('some html', 'my-groovy-style')
# *
# *  The above will open a facebox with "some html" as the content.
# *
# *    jQuery.facebox(function($) {
# *      $.get('blah.html', function(data) { $.facebox(data) })
# *    })
# *
# *  The above will show a loading screen before the passed function is called,
# *  allowing for a better ajaxy experience.
# *
# *  The facebox function can also display an ajax page, an image, or the contents of a div:
# *
# *    jQuery.facebox({ ajax: 'remote.html' })
# *    jQuery.facebox({ ajax: 'remote.html' }, 'my-groovy-style')
# *    jQuery.facebox({ image: 'stairs.jpg' })
# *    jQuery.facebox({ image: 'stairs.jpg' }, 'my-groovy-style')
# *    jQuery.facebox({ div: '#box' })
# *    jQuery.facebox({ div: '#box' }, 'my-groovy-style')
# *
# *  Want to close the facebox?  Trigger the 'close.facebox' document event:
# *
# *    jQuery(document).trigger('close.facebox')
# *
# *  Facebox also has a bunch of other hooks:
# *
# *    loading.facebox
# *    beforeReveal.facebox
# *    reveal.facebox (aliased as 'afterReveal.facebox')
# *    init.facebox
# *    afterClose.facebox
# *
# *  Simply bind a function to any of these hooks:
# *
# *   $(document).bind('reveal.facebox', function() { ...stuff to do after the facebox and contents are revealed... })
# *
# 


$.facebox = (data, klass) ->
  $.facebox.loading data.settings or []
  if data.ajax
    fillFaceboxFromAjax data.ajax, klass
  else if data.image
    fillFaceboxFromImage data.image, klass
  else if data.div
    fillFaceboxFromHref data.div, klass
  else if $.isFunction(data)
    data.call $
  else
    $.facebox.reveal data, klass

# Public, $.facebox methods
$.extend $.facebox,
  settings:
    opacity: 0.2
    overlay: true
    imageTypes: ["png", "jpg", "jpeg", "gif"]
    faceboxHtml: """
      <div id="facebox" style="display:none;">
        <div class="popup">
          <div class="content"></div>
          <a href="#" class="close"></a>
        </div>
      </div>
    """

  loading: ->
    init()
    return true  if $("#facebox .loading").length is 1
    showOverlay()
    $("#facebox .content").empty().append "<div class='loading'><img src='#{$.facebox.settings.loadingImage}'></div>"
    $("#facebox").show().css
      top: getPageScroll()[1] + (getPageHeight() / 10)
      left: $(window).width() / 2 - ($("#facebox .popup").outerWidth() / 2)

    $(document).bind "keydown.facebox", (e) ->
      $.facebox.close()  if e.keyCode is 27
      true

    $(document).trigger "loading.facebox"

  reveal: (data, klass) ->
    $(document).trigger "beforeReveal.facebox"
    $("#facebox .content").addClass klass  if klass
    $("#facebox .content").empty().append data
    $("#facebox .popup").children().fadeIn "normal"
    $("#facebox").css "left", $(window).width() / 2 - ($("#facebox .popup").outerWidth() / 2)
    $(document).trigger("reveal.facebox").trigger "afterReveal.facebox"

  close: ->
    $(document).trigger "close.facebox"
    false

# Public, $.fn methods
$.fn.facebox = (settings) ->
  clickHandler = ->
    $.facebox.loading true
    
    # support for rel="facebox.inline_popup" syntax, to add a class
    # also supports deprecated "facebox[.inline_popup]" syntax
    klass = @rel.match(/facebox\[?\.(\w+)\]?/)
    klass = klass[1]  if klass
    fillFaceboxFromHref @href, klass
    false
  return init(settings)  if $(this).length is 0
  @bind "click.facebox", clickHandler


# Private methods

# called one time to setup facebox on this page
init = (settings) ->
  if $.facebox.settings.inited
    return true
  else
    $.facebox.settings.inited = true
  $(document).trigger "init.facebox"
  makeCompatible()
  imageTypes = $.facebox.settings.imageTypes.join("|")
  $.facebox.settings.imageTypesRegexp = new RegExp("\\.(" + imageTypes + ")(\\?.*)?$", "i")
  $.extend $.facebox.settings, settings  if settings
  $("body").append $.facebox.settings.faceboxHtml
  preload = [new Image(), new Image()]
  preload[0].src = $.facebox.settings.closeImage
  preload[1].src = $.facebox.settings.loadingImage
  $("#facebox").find(".b:first, .bl").each ->
    preload.push new Image()
    preload.slice(-1).src = $(this).css("background-image").replace(/url\((.+)\)/, "$1")

  $("#facebox .close").click($.facebox.close).append "<img src=\"" + $.facebox.settings.closeImage + "\" class=\"close_image\" title=\"close\">"

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

# Backwards compatibility
makeCompatible = ->
  $s = $.facebox.settings
  $s.loadingImage = $s.loading_image or $s.loadingImage
  $s.closeImage = $s.close_image or $s.closeImage
  $s.imageTypes = $s.image_types or $s.imageTypes
  $s.faceboxHtml = $s.facebox_html or $s.faceboxHtml

# Figures out what you want to display and displays it
# formats are:
#     div: #id
#   image: blah.extension
#    ajax: anything else
fillFaceboxFromHref = (href, klass) ->
  
  # div
  if href.match(/#/)
    url = window.location.href.split("#")[0]
    target = href.replace(url, "")
    $.facebox.reveal $(target).html(), klass  if target is "#"
  
  # image
  else if href.match($.facebox.settings.imageTypesRegexp)
    fillFaceboxFromImage href, klass
  
  # ajax
  else
    fillFaceboxFromAjax href, klass
fillFaceboxFromImage = (href, klass) ->
  image = new Image()
  image.onload = ->
    $.facebox.reveal "<div class=\"image\"><img src=\"" + image.src + "\" /></div>", klass

  image.src = href

fillFaceboxFromAjax = (href, klass) ->
  $.facebox.jqxhr = $.get(href, (data) ->
    $.facebox.reveal data, klass
  )

skipOverlay = ->
  $.facebox.settings.overlay is false or $.facebox.settings.opacity is null

hideOverlay = ->
  if skipOverlay()
    return $("#facebox_overlay").fadeOut(200, ->
      $("#facebox_overlay").removeClass "facebox_overlayBG"
      $("#facebox_overlay").addClass "facebox_hide"
      $("#facebox_overlay").remove()
    )
  false

showOverlay = ->
  return if skipOverlay()
  $("body").append "<div id=\"facebox_overlay\" class=\"facebox_hide\"></div>"  if $("#facebox_overlay").length is 0
  $("#facebox_overlay").hide().addClass("facebox_overlayBG").css("opacity", $.facebox.settings.opacity).click(->
    $(document).trigger "close.facebox"
  ).fadeIn 200
  false

# Bindings
$(document).bind "close.facebox", ->
  if $.facebox.jqxhr
    $.facebox.jqxhr.abort()
    $.facebox.jqxhr = null
  $(document).unbind "keydown.facebox"
  $("#facebox").fadeOut ->
    $("#facebox .content").removeClass().addClass "content"
    $("#facebox .loading").remove()
    $(document).trigger "afterClose.facebox"

  hideOverlay()
