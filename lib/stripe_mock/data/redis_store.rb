require 'json'

module StripeMock
  class RedisStore
    attr_reader :type

    extend ::Forwardable
    include ::Enumerable

    class << self
      attr_writer :redis

      def redis
        @redis ||= Redis.new
      end
    end

    def initialize(type, data = nil)
      @type = type
      @store = self.class.redis

      Array(data).each { |obj| create(obj) }
    end

    def [](id)
      find(id)
    end

    def []=(_id, params)
      create_or_update(params)
    end

    def each
      keys.each { |id| yield find(id) }
    end

    def keys
      @store.keys("#{type}:*").map { |k| k.split(':').last }
    end

    def size
      keys.size
    end

    def delete(id)
      @store.del("#{type}:#{id}")
    end

    def values
      keys.map { |id| find(id) }
    end

    def to_json
      values.to_json
    end

    private

    def id?(params)
      fail "missing id: #{params.inspect}" unless params[:id]
    end

    def find(id)
      params = @store.get("#{type}:#{id}")

      return unless params

      Stripe::Util.symbolize_names(JSON.parse(params))
    end

    def create(params)
      id?(params)
      fail "#{type} #{params[:id]} exists!" if find(params[:id])

      @store.set("#{type}:#{params[:id]}", params.to_json)
    end

    def create_or_update(params)
      id?(params)

      existing = find(params[:id]) || {}

      @store.set("#{type}:#{params[:id]}", existing.merge(params).to_json)
    end

  end
end
