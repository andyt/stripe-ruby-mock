require 'forwardable'

require 'stripe_mock/data'
require 'stripe_mock/data/memory_store'

module StripeMock
  class Repository
    attr_reader :accounts, :bank_tokens, :card_tokens, :charges, :coupons, :customers, :disputes, :events,
                :invoices, :invoice_items, :orders, :plans, :recipients, :transfers, :subscriptions

    def initialize(backend_class, data = {})
      @accounts = backend_class.new('accounts', data[:accounts])
      @bank_tokens = backend_class.new('bank_tokens', data[:bank_tokens])
      @card_tokens = backend_class.new('card_tokens', data[:card_tokens])
      @customers = backend_class.new('customers', data[:customers])
      @charges = backend_class.new('charges', data[:charges])
      @coupons = backend_class.new('coupons', data[:coupons])
      @disputes = backend_class.new('disputes', data[:disputes])
      @events = backend_class.new('events', data[:events])
      @invoices = backend_class.new('invoices', data[:invoices])
      @invoice_items = backend_class.new('invoice_items', data[:invoice_items])
      @orders = backend_class.new('orders', data[:orders])
      @plans = backend_class.new('plans', data[:plans])
      @recipients = backend_class.new('recipients', data[:recipients])
      @transfers = backend_class.new('transfers', data[:transfers])
      @subscriptions = backend_class.new('subscriptions', data[:subscriptions])
    end
  end
end
