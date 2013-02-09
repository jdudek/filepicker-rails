require "uri"

module Filepicker
  module Rails

    module ViewHelpers
      def filepicker_js_include_tag
        javascript_include_tag "//api.filepicker.io/v0/filepicker.js"
      end

      def filepicker_async_js_include_tag
        javascript_tag <<-JS
          (function(a){if(window.filepicker){return}var b=a.createElement("script");b.type="text/javascript";b.async=!0;b.src=("https:"===a.location.protocol?"https:":"http:")+"//api.filepicker.io/v1/filepicker.js";var c=a.getElementsByTagName("script")[0];c.parentNode.insertBefore(b,c);var d={};d._queue=[];var e="pick,pickMultiple,pickAndStore,read,write,writeUrl,export,convert,store,storeUrl,remove,stat,setKey,constructWidget,makeDropPane".split(",");var f=function(a,b){return function(){b.push([a,arguments])}};for(var g=0;g<e.length;g++){d[e[g]]=f(e[g],d._queue)}window.filepicker=d})(document);
        JS
      end

      def filepicker_save_button(text, url, mimetype, options = {})
        options[:data] ||= {}
        container = options.delete(:container)
        services = options.delete(:services)
        save_as = options.delete(:save_as_name)

        options[:data]['fp-url'] = url
        options[:data]['fp-apikey'] = Filepicker::Rails.config.api_key
        options[:data]['fp-mimetype'] = mimetype
        options[:data]['fp-option-container'] = container if container
        options[:data]['fp-option-services'] = Array(services).join(",") if services
        options[:data]['fp-option-defaultSaveasName'] = save_as if save_as
        button_tag(text, options)
      end


      def filepicker_image_tag(url, options={})
        if url.match(/^https:\/\/www.filepicker.io\/api\/file\/(\w*)/).nil?
          image_tag(url, options.slice(:width, :height, :alt))
        else
          image_tag(filepicker_image_url(url, options), options.slice(:alt))
        end
      end

      # w - Resize the image to this width.
      #
      # h - Resize the image to this height.
      #
      # fit - Specifies how to resize the image. Possible values are:
      #       clip: Resizes the image to fit within the specified parameters without
      #             distorting, cropping, or changing the aspect ratio
      #       crop: Resizes the image to fit the specified parameters exactly by
      #             removing any parts of the image that don't fit within the boundaries
      #       scales: Resizes the image to fit the specified parameters exactly by
      #               scaling the image to the desired size
      #       Defaults to "clip".
      #
      # crop - Crops the image to a specified rectangle. The input to this parameter
      #        should be 4 numbers for 'x,y,width,height' - for example,
      #        'crop=10,20,200,250' would select the 200x250 pixel rectangle starting
      #        from 10 pixels from the left edge and 20 pixels from the top edge of the
      #        image.
      #
      # format - Specifies what format the image should be converted to, if any.
      #          Possible values are "jpg" and "png". For "jpg" conversions, you
      #          can additionally specify a quality parameter.
      #
      # quality - For jpeg conversion, specifies the quality of the resultant image.
      #           Quality should be an integer between 1 and 100
      #
      # watermark - Adds the specified absolute url as a watermark on the image.
      #
      # watersize - This size of the watermark, as a percentage of the base
      #             image (not the original watermark).
      #
      # waterposition - Where to put the watermark relative to the base image.
      #                 Possible values for vertical position are "top","middle",
      #                 "bottom" and "left","center","right", for horizontal
      #                 position. The two can be combined by separating vertical
      #                 and horizontal with a comma. The default behavior
      #                 is bottom,right
      def filepicker_image_url(url, options = {})
        query_params = options.slice(:width, :height, :fit, :crop, :align, :format, :quality, :watermark, :watersize, :waterposition).to_query
        [url, "/convert?", query_params].join
      end
    end
  end
end
