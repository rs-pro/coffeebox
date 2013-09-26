# v1.4 
#Copyright (c) 2009 Dimas Begunoff, http://www.farinspace.com
#
#https://github.com/farinspace/jquery.imgpreload
#
# Licensed under the MIT:
#   http://www.opensource.org/licenses/mit-license.php

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
          settings.each.call(img_obj) if settings.each instanceof Function
          
          # http://jsperf.com/length-in-a-variable
          if loaded.length >= imgs.length and settings.all instanceof Function
            settings.all.call(loaded) 

          $(this).unbind "load error"

        img.src = url


    $.fn.imgpreload = (settings) ->
      $.imgpreload this, settings
      this

    $.fn.imgpreload.defaults =
      each: null # callback invoked when each image in a group loads
      all: null # callback invoked when when the entire group of images has loaded
  ) jQuery


