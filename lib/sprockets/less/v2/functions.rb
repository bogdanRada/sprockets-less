module Sprockets
  module Less
    module V2
      # Sprockets-aware Less functions
      module Functions
        def asset_data_url(path)
          value = sprockets_context.asset_data_uri(path)
          fetch_css_url(value)
        end

        def asset_path(path, options = {})
          if options.is_a?(Hash) && options.keys.size > 0
            valeu = quote(sprockets_context.asset_path(path, map_options(options)))
          else
            valeu= quote(public_path(path))
          end
          puts valeu
          valeu
        end

        def font_path(source, options = {})
          quote(sprockets_context.font_path(source, map_options(options)))
        end

        # Using Sprockets::Helpers#font_path, return the url CSS
        # for the given +source+ as a Sass String. This supports keyword
        # arguments that mirror the +options+.
        #
        # === Examples
        #
        #   src: font-url("font.ttf");                  // src: url("/assets/font.ttf");
        #   src: font-url("image.jpg", $digest: true);  // src: url("/assets/font-27a8f1f96afd8d4c67a59eb9447f45bd.ttf");
        #
        def font_url(source, options = {})
          # Work with the Compass #font_url API
          "url(#{font_path(source, options)})"
        end


        def asset_url(path, options = {})
          "url(#{asset_path(path, options)})"
        end

        def image_path(img, options = {})
          fetch_css_url(sprockets_context.image_path(img, map_options(options)))
        end

        def asset_data_uri(source)
          fetch_css_url(sprockets_context.asset_data_uri(source), :unquote => true)
        end

        def image_url(img, options = {})
          image_path(img, options)
        end

        def video_path(video)
          fetch_css_url(sprockets_context.video_path(video))
        end

        def video_url(video)
          fetch_css_url(sprockets_context.video_path(video))
        end

        def audio_path(audio)
          fetch_css_url(sprockets_context.audio_path(audio))
        end

        def audio_url(audio)
          fetch_css_url(sprockets_context.audio_path(audio))
        end

        def javascript_path(javascript)
          fetch_css_url(context.javascript_path(javascript))
        end

        def javascript_url(javascript)
          fetch_css_url(context.javascript_path(javascript))
        end

        def stylesheet_path(stylesheet)
          sprockets_context.stylesheet_path(stylesheet).inspect
        end

        def stylesheet_url(stylesheet)
          fetch_css_url(sprockets_context.stylesheet_path(stylesheet))
        end

        protected

        def public_path(asset)
          if sprockets_context.respond_to?(:asset_paths)
            sprockets_context.asset_paths.compute_public_path asset, defined?(Rails) ? ::Rails.application.config.assets.prefix : '/assets'
          else
            sprockets_context.path_to_asset(asset)
          end
        end

        def fetch_content_type(extension = nil)
          return nil if extension.nil?
          Rack::Mime::MIME_TYPES[".#{extension}"]
        end

        def fetch_css_url(value ,options = {})
          "url(#{quote(value, options)})"
        end

        def quote(contents, opts = {})
          return contents if opts[:unquote]
          contents = contents.gsub(/\n\s*/, ' ')
          quote = opts[:quote]

          # Short-circuit if there are no characters that need quoting.
          unless contents =~ /[\n\\"']|\#\{/
            quote ||= '"'
            return "#{quote}#{contents}#{quote}"
          end

          if quote.nil?
            if contents.include?('"')
              if contents.include?("'")
                quote = '"'
              else
                quote = "'"
              end
            else
              quote = '"'
            end
          end

          # Replace single backslashes with multiples.
          contents = contents.gsub("\\", "\\\\\\\\")

          # Escape interpolation.
          contents = contents.gsub('#{', "\\\#{") if opts[:sass]

          if quote == '"'
            contents = contents.gsub('"', "\\\"")
          else
            contents = contents.gsub("'", "\\'")
          end

          contents = contents.gsub(/\n(?![a-fA-F0-9\s])/, "\\a").gsub("\n", "\\a ")
          "#{quote}#{contents}#{quote}"
        end

        # Returns an options hash where the keys are symbolized
        # and the values are unwrapped Sass literals.
        def map_options(options = {}) # :nodoc:
          map_hash(options) do |key, value|
            [key.to_sym, value.respond_to?(:value) ? value.value : value]
          end
        end

        def map_hash(hash)
          # Copy and modify is more performant than mapping to an array and using
          # to_hash on the result.
          rv = hash.class.new
          hash.each do |k, v|
            new_key, new_value = yield(k, v)
            new_key = hash.denormalize(new_key) if hash.is_a?(NormalizedMap) && new_key == k
            rv[new_key] = new_value
          end
          rv
        end

      end
    end
  end
end
