module StripeMock
  # This mirrors the existing hash-like implementation, and clarifies which parts of the Hash API are accessed.
  # We'll refactor away from this to give a MemoryStore a better API.
  class MemoryStore
    attr_reader :type

    extend ::Forwardable
    include ::Enumerable

    # legacy API support via new API
    alias_method :[], :find

    # legacy API
    def_delegators :@repository, :[], :[]=, :values, :keys, :delete, :size
    def_delegators :values, :select, :each, :to_json

    def initialize(type, data = nil)
      @type = type
      @repository = {}

      Array(data).each { |obj| create(obj) }
    end

    def create(params)
      fail "missing id: #{params.inspect}" unless params[:id]
      fail "#{type} #{params[:id]} exists!" if find(params[:id])

      @repository[params[:id]] = params
    end

    def find(id)
      @repository[id]
    end

    # def []=(_key, params)
    #   create(params)
    # end

    # def all
    #   @repository.values
    # end

    # def update(id, params)
    #   find(id).merge!(params)
    # end

    # def delete(id)
    #   @repository.delete(id)
    # end
  end
end
