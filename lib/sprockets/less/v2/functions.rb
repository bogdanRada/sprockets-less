module Sprockets
  module Less
    module V2
      # Sprockets-aware Less functions
      module Functions
        def asset_data_url(path)
          "url(#{sprockets_context.asset_data_uri(path)})"
        end

        def asset_path(asset)
          public_path(asset).inspect
        end

        def asset_url(asset)
          "url(#{public_path(asset)})"
        end

        def image_path(img)
          sprockets_context.image_path(img).inspect
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
          sprockets_context.asset_paths.compute_public_path asset, '/assets'
        end

        def context_asset_data_uri(path)

        end
      end
    end
  end
end
