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
            sprockets_context.asset_path(path, map_options(options))
          else
            fetch_css_url(public_path(path))
          end
        end

        def asset_url(path, options = {})
          asset_path(path, options)
        end

        def image_path(img)
          quote(sprockets_context.image_path(img).to_s)
        end

        def asset_data_uri(source)
          "url(#{sprockets_context.asset_data_uri(source.value)})"
        end

        def image_url(img)
          "url(#{sprockets_context.image_path(img)})"
        end

        def video_path(video)
          sprockets_context.video_path(video).inspect
        end

        def video_url(video)
          "url(#{sprockets_context.video_path(video)})"
        end

        def audio_path(audio)
          sprockets_context.audio_path(audio).inspect
        end

        def audio_url(audio)
          "url(#{context.audio_path(audio)})"
        end

        def javascript_path(javascript)
          context.javascript_path(javascript).inspect
        end

        def javascript_url(javascript)
          "url(#{context.javascript_path(javascript)})"
        end

        def stylesheet_path(stylesheet)
          sprockets_context.stylesheet_path(stylesheet).inspect
        end

        def stylesheet_url(stylesheet)
          "url(#{sprockets_context.stylesheet_path(stylesheet)})"
        end

        protected

        def public_path(asset)
          if defined?(Rails) && sprockets_context.respond_to?(:asset_paths)
            sprockets_context.asset_paths.compute_public_path asset, ::Rails.application.config.assets.prefix
          else
            sprockets_context.path_to_asset(asset)
          end
        end

        def fetch_content_type(extension = nil)
          return nil if extension.nil?
          Rack::Mime::MIME_TYPES[".#{extension}"]
        end

        def fetch_css_url(value)
          "url(#{quote(value)})"
        end

        def quote(contents, opts = {})
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
