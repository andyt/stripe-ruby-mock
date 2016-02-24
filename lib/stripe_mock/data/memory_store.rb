module StripeMock
  # This mirrors the existing hash-like implementation, and clarifies which parts of the Hash API are accessed.
  # We'll refactor away from this to give a MemoryStore a better API.
  class MemoryStore
    attr_reader :type

    extend ::Forwardable
    include ::Enumerable

    def_delegators :@store, :values, :keys, :delete, :size
    def_delegators :values, :select, :each, :to_json

    def initialize(type, data = nil)
      @type = type
      @store = {}

      Array(data).each { |obj| create(obj) }
    end

    def [](id)
      find(id)
    end

    def []=(_id, params)
      create_or_update(params)
    end

    private

    def id?(params)
      fail "missing id: #{params.inspect}" unless params[:id]
    end

    def find(id)
      @store[id]
    end

    def create(params)
      id?(params)
      fail "#{type} #{params[:id]} exists!" if find(params[:id])

      @store[params[:id]] = params
    end

    def create_or_update(params)
      id?(params)

      existing = find(params[:id]) || {}

      @store[params[:id]] = existing.merge(params)
    end
  end
end
