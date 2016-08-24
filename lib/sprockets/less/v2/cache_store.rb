# frozen_string_literal: true
module Sprockets
  module Less
    module V2
      # Internal: Cache wrapper for Sprockets cache adapter. (Sprockets 2.x)
      class CacheStore
        attr_reader :environment

        def initialize(environment)
          @environment = environment
        end

        def _store(key, version, sha, contents)
            raise "bla"
          environment.send :cache_set, "less/#{key}", version: version, sha: sha, contents: contents
        end

        def _retrieve(key, version, sha)
            raise "bla"
          obj = environment.send(:cache_get, "less/#{key}")
          return unless obj.is_a?(Hash)
          return if obj[:version] != version || obj[:sha] != sha
          obj[:obj]
        end


        # Store a {Sass::Tree::RootNode}.
        #
        # @param key [String] The key to store it under.
        # @param sha [String] The checksum for the contents that are being stored.
        # @param root [Object] The root node to cache.
        def store(key, sha, root)
            raise "bla"
          _store(key, Less::VERSION, sha, Marshal.dump(root))

        end

        # Retrieve a {Sass::Tree::RootNode}.
        #
        # @param key [String] The key the root element was stored under.
        # @param sha [String] The checksum of the root element's content.
        # @return [Object] The cached object.
        def retrieve(key, sha)
              raise "bla"
          contents = _retrieve(key, Less::VERSION, sha)
          Marshal.load(contents) if contents
        end

        # Return the key for the sass file.
        #
        # The `(sass_dirname, sass_basename)` pair
        # should uniquely identify the Sass document,
        # but otherwise there are no restrictions on their content.
        #
        # @param sass_dirname [String]
        #   The fully-expanded location of the Sass file.
        #   This corresponds to the directory name on a filesystem.
        # @param sass_basename [String] The name of the Sass file that is being referenced.
        #   This corresponds to the basename on a filesystem.
        def key(sass_dirname, sass_basename)
raise "aaa"
          dir = Digest::SHA1.hexdigest(sass_dirname)
          filename = "#{sass_basename}c"
          "#{dir}/#{filename}"
        end


      end
    end
  end
end
