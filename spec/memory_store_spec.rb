require 'spec_helper'

require 'stripe_mock/data/memory_store'

describe StripeMock::MemoryStore do
  # def_delegators :@repository, :[], :[]=, :values, :keys, :delete, :size
  # def_delegators :values, :select, :each, :to_json

  let(:store) { StripeMock::MemoryStore.new('object') }

  let(:object) do
    { id: 1 }
  end

  before { store[1] = object }

  describe '.new' do
    it 'accepts an array of initial data items' do
      store = StripeMock::MemoryStore.new('object', [object])

      expect(store.size).to eq 1
      expect(store[1]).to eq object
    end
  end

  describe '#type' do
    it 'returns the supplied type' do
      expect(store.type).to eq 'object'
    end
  end

  describe '#[]' do
    it 'finds an object by ID' do
      expect(store[1]).to eq object
    end
  end

  describe '#[]' do
    it 'stores an object by ID' do
      store[2] = object
      expect(store[2]).to eq object
    end
  end

  describe '#values' do
    it 'returns an array of all objects' do
      expect(store.values).to eq [object]
    end
  end

  describe '#keys' do
    it 'returns an array of all object IDs' do
      expect(store.keys).to eq [1]
    end
  end

  describe '#delete' do
    it 'deletes an object by ID' do
      store.delete(1)

      expect(store[1]).to eq nil
    end
  end

  describe '#each' do
    it 'yields each object' do
      expect { |b| store.each(&b) }.to yield_with_args(object)
    end
  end

  describe '#size' do
    it 'returns a count of the values' do
      expect(store.size).to eq 1
    end
  end

  describe '#to_json' do
    it 'returns a JSON array of the values' do
      expect(store.to_json).to eq '[{"id":1}]'
    end
  end
end
