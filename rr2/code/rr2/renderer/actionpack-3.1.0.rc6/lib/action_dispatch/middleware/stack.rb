#---
# Excerpted from "Rails Recipes",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rr2 for more book information.
#---
require "active_support/inflector/methods"
require "active_support/dependencies"

module ActionDispatch
  class MiddlewareStack
    class Middleware
      attr_reader :args, :block, :name, :classcache

      def initialize(klass_or_name, *args, &block)
        @klass = nil

        if klass_or_name.respond_to?(:name)
          @klass = klass_or_name
          @name  = @klass.name
        else
          @name  = klass_or_name.to_s
        end

        @classcache = ActiveSupport::Dependencies::Reference
        @args, @block = args, block
      end

      def klass
        @klass || classcache[@name]
      end

      def ==(middleware)
        case middleware
        when Middleware
          klass == middleware.klass
        when Class
          klass == middleware
        else
          normalize(@name) == normalize(middleware)
        end
      end

      def inspect
        klass.to_s
      end

      def build(app)
        klass.new(app, *args, &block)
      end

    private

      def normalize(object)
        object.to_s.strip.sub(/^::/, '')
      end
    end

    include Enumerable

    attr_accessor :middlewares

    def initialize(*args)
      @middlewares = []
      yield(self) if block_given?
    end

    def each
      @middlewares.each { |x| yield x }
    end

    def size
      middlewares.size
    end

    def last
      middlewares.last
    end

    def [](i)
      middlewares[i]
    end

    def initialize_copy(other)
      self.middlewares = other.middlewares.dup
    end

    def insert(index, *args, &block)
      index = assert_index(index, :before)
      middleware = self.class::Middleware.new(*args, &block)
      middlewares.insert(index, middleware)
    end

    alias_method :insert_before, :insert

    def insert_after(index, *args, &block)
      index = assert_index(index, :after)
      insert(index + 1, *args, &block)
    end

    def swap(target, *args, &block)
      insert_before(target, *args, &block)
      delete(target)
    end

    def delete(target)
      middlewares.delete target
    end

    def use(*args, &block)
      middleware = self.class::Middleware.new(*args, &block)
      middlewares.push(middleware)
    end

    def build(app = nil, &block)
      app ||= block
      raise "MiddlewareStack#build requires an app" unless app
      middlewares.reverse.inject(app) { |a, e| e.build(a) }
    end

  protected

    def assert_index(index, where)
      i = index.is_a?(Integer) ? index : middlewares.index(index)
      raise "No such middleware to insert #{where}: #{index.inspect}" unless i
      i
    end
  end
end