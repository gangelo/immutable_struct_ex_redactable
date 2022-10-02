# frozen_string_literal: true

# rubocop:disable RSpec/MultipleExpectations
RSpec.describe ImmutableStructExRedactable do
  let(:config) { described_class.configuration }
  let(:hash) do
    {
      first: 'first',
      last: 'last',
      password: 'p@ssword',
      ssn: 'ssn',
      dob: '2022-10-01'
    }
  end

  it 'has a version number' do
    expect(ImmutableStructExRedactable::VERSION).not_to be_nil
  end

  describe '#create' do
    subject(:create) do
      described_class.create(**hash)
    end

    context 'with no redacted fields configured' do
      before do
        described_class.configure do |config|
          config.redacted = %i[]
        end
      end

      it 'does not redact any field values' do
        expect(create.first).to eq hash[:first]
        expect(create.last).to eq hash[:last]
        expect(create.password).to eq hash[:password]
        expect(create.ssn).to eq hash[:ssn]
        expect(create.dob).to eq hash[:dob]
      end
    end

    context 'with redacted fields configured' do
      before do
        described_class.configure do |config|
          config.redacted = %i[password ssn dob]
        end
      end

      it 'redacts the correct field values' do
        expect(create.password).to eq config.redacted_label
        expect(create.ssn).to eq config.redacted_label
        expect(create.dob).to eq config.redacted_label
      end

      it 'does not redact non-redacted field values' do
        expect(create.first).to eq hash[:first]
        expect(create.last).to eq hash[:last]
      end
    end

    context 'when passing a &block' do
      subject(:create) do
        described_class.create(**hash) do
          def block_passed?
            true
          end
        end
      end

      before do
        described_class.configure do |config|
          config.redacted = %i[password ssn dob]
        end
      end

      it 'accepts the &block' do
        expect { create }.not_to raise_error
        expect(create.block_passed?).to be true
      end
    end
  end

  describe '#create_with' do
    subject(:create_with) do
      described_class.create_with(config, **hash)
    end

    let(:config) do
      described_class::Configuration.new.tap do |config|
        config.redacted = redacted
        config.redacted_label = redacted_label
      end
    end
    let(:redacted) { %i[first last] }
    let(:redacted_label) { 'x' }

    context 'with no redacted fields configured' do
      let(:redacted) { %i[] }

      it 'does not redact any field values' do
        expect(create_with.first).to eq hash[:first]
        expect(create_with.last).to eq hash[:last]
        expect(create_with.password).to eq hash[:password]
        expect(create_with.ssn).to eq hash[:ssn]
        expect(create_with.dob).to eq hash[:dob]
      end
    end

    context 'with redacted fields configured' do
      it 'redacts the correct field values' do
        expect(create_with.first).to eq config.redacted_label
        expect(create_with.last).to eq config.redacted_label
      end

      it 'does not redact non-redacted field values' do
        expect(create_with.password).to eq hash[:password]
        expect(create_with.ssn).to eq hash[:ssn]
        expect(create_with.dob).to eq hash[:dob]
      end
    end

    context 'when passing a &block' do
      subject(:create_with) do
        described_class.create_with(config, **hash) do
          def block_passed?
            true
          end
        end
      end

      it 'accepts the &block' do
        expect { create_with }.not_to raise_error
        expect(create_with.block_passed?).to be true
      end
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations
