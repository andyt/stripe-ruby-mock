require 'spec_helper'

require 'stripe_mock/data/repository'
require 'stripe_mock/data/memory_store'

describe StripeMock::Repository do
  def self.object_types
    %i(accounts bank_tokens card_tokens charges coupons customers disputes events invoices invoice_items orders plans recipients transfers subscriptions)
  end

  let(:data) do
    {
      charges: [StripeMock::Data.mock_charge(id: 'ch_1234')],
      disputes: StripeMock::Data.mock_disputes(['dp_05RsQX2eZvKYlo2C0FRTGSSA', 'dp_15RsQX2eZvKYlo2C0ERTYUIA'])
    }
  end

  object_types.each do |object_type|
    it "has an accessor to the store for #{object_type}" do
      backend_class = double('backend_class', new: true)

      expect(backend_class).to receive(:new).with(object_type.to_s, data[object_type]).and_return(:"#{object_type}_store")

      repository = StripeMock::Repository.new(backend_class, data)

      expect(repository.send(object_type)).to eq :"#{object_type}_store"
    end
  end

  context 'with a MemoryStore' do
    it 'stores initial data' do
      store = StripeMock::Repository.new(StripeMock::MemoryStore, data)

      expect(store.charges.size).to eq 1
      expect(store.charges['ch_1234']).to eq data[:charges].first

      expect(store.disputes.size).to eq 2
      expect(store.disputes['dp_05RsQX2eZvKYlo2C0FRTGSSA']).to eq data[:disputes].first
      expect(store.disputes['dp_15RsQX2eZvKYlo2C0ERTYUIA']).to eq data[:disputes].last
    end
  end
end
