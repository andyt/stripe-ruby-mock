require 'forwardable'

require 'stripe_mock/data'

module StripeMock
  class Repository
    attr_reader :accounts, :bank_tokens, :card_tokens, :charges, :coupons, :customers, :disputes, :events,
                :invoices, :invoice_items, :orders, :plans, :recipients, :transfers, :subscriptions

    # This mirrors the existing hash-like implementation, and clarifies which parts of the Hash API are accessed.
    # We'll refactor away from this to give a MemoryStore a better API.
    class MemoryStore < BasicObject
      extend ::Forwardable
      include ::Enumerable

      def_delegators :@repository, :[], :[]=, :values, :keys, :delete, :delete_if, :each, :merge!, :clone, :respond_to?, :size, :to_json, :inspect

      def initialize
        @repository = {}
      end
    end

    def initialize(data = {})
      @accounts = MemoryStore.new
      @bank_tokens = MemoryStore.new
      @card_tokens = MemoryStore.new
      @customers = MemoryStore.new
      @charges = MemoryStore.new
      @coupons = MemoryStore.new
      @disputes = MemoryStore.new
      @events = MemoryStore.new
      @invoices = MemoryStore.new
      @invoice_items = MemoryStore.new
      @orders = MemoryStore.new
      @plans = MemoryStore.new
      @recipients = MemoryStore.new
      @transfers = MemoryStore.new
      @subscriptions = MemoryStore.new

      persist_initial_data(data)
    end

    private

    def persist_initial_data(data)
      data.each do |k, v|
        model_repository = send(k)

        if v.is_a?(Hash)
          if v.key?(:id) # single object
            model_repository[v[:id]] = v
          else # hash of objects with IDs as keys
            model_repository.merge!(v)
          end
        elsif v.is_a?(Array)
          v.each do |obj|
            model_repository[obj[:id]] = obj
          end
        else
          fail 'Unknown data format'
        end
      end
    end
  end
end
