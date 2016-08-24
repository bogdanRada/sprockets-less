module Less

  # Wrapper for the `tree` JavaScript module.
  #
  # This is not to be confused with Less::Parser::Tree, as Less uses that
  # to wrap the AST (which is actually a tree.RuleSet) resulting from parsing
  class Tree
    attr_reader :sprockets_context

    def initialize(options)
      @tree = Less.instance_eval { @loader.require('less/tree') }
    #  @sprockets_context = options[:importer].context
      extend_js Sprockets::Less::Utils.get_class_by_version("Functions")
    end

    private

    # Transforms a css function name string to a (method) symbol
    def css_to_sym(str)
      str.gsub('-','_').to_sym
    end

    # Transforms a method symbol to a css function name string
    def sym_to_css(sym)
      sym.to_sym.to_s.gsub('_', '-')
    end

    # Removes quotes
    def unquote(str)
      s = str.to_s.strip
      s =~ /^['"](.*?)['"]$/ ? $1 : s
    end

    # Creates a JavaScript anonymous function from a Ruby block
    def anonymous_function(block)
      lambda do |*args|
        # args: (this, node) v8 >= 0.10, otherwise (node)
        raise ArgumentError, "missing node" if args.empty?
        @tree[:Anonymous].new block.call(@tree, args.last)
      end
    end

    # Access to the Less JavaScript function object
    def functions
      @tree['functions']
    end

    # Injects a Ruby method into the JavaScript Less
    def add_function(name, &block)
      functions[name] = anonymous_function(block)
    end

    # Adds all of a module's public instance methods as Less functions
    def extend_js(mod)
      extend mod
      mod.public_instance_methods.each do |method_name|
        add_function(sym_to_css(method_name)) { |tree, cxt|
          send method_name.to_sym, unquote(cxt.toCSS())
        }
      end
    end

  end

  class Parser

    attr_reader :tree

    # Override the parser's initialization to improve Less `tree`
    # with sprockets awareness
    alias_method :initialize_without_tree, :initialize
    def initialize(options={})
      initialize_without_tree(options)
      @tree = Less::Tree.new(options)
    end
  end
end
