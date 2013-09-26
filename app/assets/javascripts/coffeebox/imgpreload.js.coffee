# v1.4 

#
#
#Copyright (c) 2009 Dimas Begunoff, http://www.farinspace.com
#
#https://github.com/farinspace/jquery.imgpreload
#
#Licensed under the MIT license
#http://en.wikipedia.org/wiki/MIT_License
#
#Permission is hereby granted, free of charge, to any person
#obtaining a copy of this software and associated documentation
#files (the "Software"), to deal in the Software without
#restriction, including without limitation the rights to use,
#copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the
#Software is furnished to do so, subject to the following
#conditions:
#
#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#OTHER DEALINGS IN THE SOFTWARE.
#
#
unless "undefined" is typeof jQuery
  (($) ->
    
    # extend jquery (because i love jQuery)
    $.imgpreload = (imgs, settings) ->
      settings = $.extend({}, $.fn.imgpreload.defaults, (if (settings instanceof Function) then all: settings else settings))
      
      # use of typeof required
      # https://developer.mozilla.org/En/Core_JavaScript_1.5_Reference/Operators/Special_Operators/Instanceof_Operator#Description
      imgs = new Array(imgs)  if "string" is typeof imgs
      loaded = new Array()
      $.each imgs, (i, elem) ->
        img = new Image()
        url = elem
        img_obj = img
        unless "string" is typeof elem
          url = $(elem).attr("src")
          img_obj = elem
        $(img).bind "load error", (e) ->
          loaded.push img_obj
          $.data img_obj, "loaded", (if ("error" is e.type) then false else true)
          settings.each.call img_obj  if settings.each instanceof Function
          
          # http://jsperf.com/length-in-a-variable
          settings.all.call loaded  if loaded.length >= imgs.length and settings.all instanceof Function
          $(this).unbind "load error"

        img.src = url


    $.fn.imgpreload = (settings) ->
      $.imgpreload this, settings
      this

    $.fn.imgpreload.defaults =
      each: null # callback invoked when each image in a group loads
      all: null # callback invoked when when the entire group of images has loaded
  ) jQuery

#
#
#	Usage:
#
#	$('#content img').imgpreload(function()
#	{
#		// this = array of dom image objects
#		// callback executes when all images are loaded
#	});
#
#	$('#content img').imgpreload
#	({
#		each: function()
#		{
#			// this = dom image object
#			// check for success with: $(this).data('loaded')
#			// callback executes when each image loads
#		},
#		all: function()
#		{
#			// this = array of dom image objects
#			// check for success with: $(this[i]).data('loaded')
#			// callback executes when all images are loaded
#		}
#	});
#
#	$.imgpreload('/images/a.gif',function()
#	{
#		// this = array of dom image objects
#		// check for success with: $(this[i]).data('loaded')
#		// callback
#	});
#
#	$.imgpreload(['/images/a.gif','/images/b.gif'],function()
#	{
#		// this = array of dom image objects
#		// check for success with: $(this[i]).data('loaded')
#		// callback executes when all images are loaded
#	});
#
#	$.imgpreload(['/images/a.gif','/images/b.gif'],
#	{
#		each: function()
#		{
#			// this = dom image object
#			// check for success with: $(this).data('loaded')
#			// callback executes on every image load
#		},
#		all: function()
#		{
#			// this = array of dom image objects
#			// check for success with: $(this[i]).data('loaded')
#			// callback executes when all images are loaded
#		}
#	});
#
#
