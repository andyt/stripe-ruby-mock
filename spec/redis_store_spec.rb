require 'spec_helper'

require 'mock_redis'
require 'stripe_mock/data/redis_store'

# So we don't need Redis as a dependency.
module Redis
end

describe StripeMock::MemoryStore do
  # def_delegators :@repository, :[], :[]=, :values, :keys, :delete, :size
  # def_delegators :values, :select, :each, :to_json

  let(:store) { StripeMock::RedisStore.new('object', [object]) }

  let(:object) do
    { id: 'ch_1' }
  end

  before do
    allow(Redis).to receive(:new).and_return(MockRedis.new)

    StripeMock::RedisStore.redis = nil
  end

  describe '.redis' do
    it 'returns Redis.new by default' do
      expect(Redis).to receive(:new).and_return(:default_redis_client)
      expect(StripeMock::RedisStore.redis).to eq :default_redis_client
    end

    it 'returns an assigned value' do
      StripeMock::RedisStore.redis = :assigned_redis_client
      expect(StripeMock::RedisStore.redis).to eq :assigned_redis_client
    end
  end

  describe '.new' do
    it 'accepts an array of initial data items' do
      expect(store.size).to eq 1
      expect(store['ch_1']).to eq object
    end
  end

  describe '#type' do
    it 'returns the supplied type' do
      expect(store.type).to eq 'object'
    end
  end

  describe '#[]' do
    it 'uses the class level Redis client' do
      expect(StripeMock::RedisStore).to receive(:redis).and_return(double('redis_client', get: nil, set: true))

      store
    end

    it 'finds an object by ID' do
      expect(store['ch_1']).to eq object
    end
  end

  describe '#[]' do
    it 'stores an object by ID' do
      charge = object.merge(id: 'ch_2')

      store['ch_2'] = charge
      expect(store['ch_2']).to eq charge
    end
  end

  describe '#values' do
    it 'returns an array of all objects' do
      expect(store.values).to eq [object]
    end
  end

  describe '#keys' do
    it 'returns an array of all object IDs' do
      expect(store.keys).to eq ['ch_1']
    end
  end

  describe '#delete' do
    it 'deletes an object by ID' do
      store.delete('ch_1')

      expect(store['ch_1']).to eq nil
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
      expect(store.to_json).to eq '[{"id":"ch_1"}]'
    end
  end
end
