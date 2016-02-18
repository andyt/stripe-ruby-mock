require 'spec_helper'

require 'stripe_mock/data/repository'
require 'stripe_mock/data'

describe StripeMock::Repository do
  def self.model_names
    %i(bank_tokens card_tokens charges coupons customers disputes events invoices invoice_items orders plans recipients transfers subscriptions)
  end

  subject { StripeMock::Repository.new }

  it 'accepts initial data for models' do
    repository = StripeMock::Repository.new(
      charges: StripeMock::Data.mock_charge,
      accounts: [StripeMock::Data.mock_account],
      disputes: StripeMock::Data.mock_disputes([
        'dp_05RsQX2eZvKYlo2C0FRTGSSA',
        'dp_15RsQX2eZvKYlo2C0ERTYUIA',
        'dp_25RsQX2eZvKYlo2C0ZXCVBNM'
        ])
    )

    expect(repository.charges.size).to eq 1
    expect(repository.accounts.size).to eq 1
    expect(repository.disputes.size).to eq 3
  end

  model_names.each do |model_name|
    it "responds to ##{model_name}" do
      expect(subject).to respond_to model_name
    end
  end
end
