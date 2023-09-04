# frozen_string_literal: true

RSpec.shared_examples 'there is private method access to blacklisted field values' do
  it 'adds private methods to access the redacted field values' do
    expect(
      blacklist.all? do |field|
        subject.send(:"unredacted_#{field}") == hash[field]
      end
    ).to be true
  end
end

RSpec.shared_examples 'there is no private method access to blacklisted field values' do
  it 'does not add private methods to access the unredacted field values' do
    subject_private_methods = subject.private_methods
    expect((blacklist - hash.keys).any? do |field|
             subject_private_methods.include? :"unredacted_#{field}"
           end).to be false
  end
end

RSpec.shared_examples 'there is private method access to non-whitelisted field values' do
  it 'adds private methods to access the redacted field values' do
    expect(
      hash.keys.all? do |field|
        next true if whitelist.include? field

        subject.send(:"unredacted_#{field}") == hash[field]
      end
    ).to be true
  end
end

RSpec.shared_examples 'there is no private method access to non-whitelisted field values' do
  it 'does not add private methods to access the unredacted field values' do
    subject_private_methods = subject.private_methods
    expect((whitelist - hash.keys).any? do |field|
             subject_private_methods.include? :"unredacted_#{field}"
           end).to be false
  end
end

RSpec.shared_examples 'there are no redacted field values' do
  it 'does not redact any field values' do
    expect(hash.keys.any? do |field|
             subject.send(field) == config.redacted_label
           end).to be false
  end
end

# rubocop:disable RSpec/MultipleExpectations
RSpec.describe ImmutableStructExRedactable do
  let(:config) { described_class.configuration }
  let(:hash) do
    {
      first: 'first',
      last: 'last',
      email: 'first.last@gmail.com',
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

    context 'with no blacklist and no whitelist fields configured' do
      before do
        described_class.configure do |config|
          config.blacklist = []
          config.whitelist = []
        end
      end

      it_behaves_like 'there are no redacted field values'
    end

    context 'with blacklisted fields configured' do
      before do
        described_class.configure do |config|
          config.blacklist = %i[password ssn dob email]
        end
      end

      it 'redacts the blacklisted field values' do
        expect(create.password).to eq config.redacted_label
        expect(create.ssn).to eq config.redacted_label
        expect(create.dob).to eq config.redacted_label
        expect(create.email).to eq config.redacted_label
      end

      it 'does not redact non-blacklisted field values' do
        expect(create.first).to eq hash[:first]
        expect(create.last).to eq hash[:last]
      end
    end

    context 'with whitelisted fields configured' do
      before do
        described_class.configure do |config|
          config.whitelist = %i[first last]
        end
      end

      it 'redacts the non-whitelisted field values' do
        expect(create.password).to eq config.redacted_label
        expect(create.ssn).to eq config.redacted_label
        expect(create.dob).to eq config.redacted_label
        expect(create.email).to eq config.redacted_label
      end

      it 'does not redact whitelisted field values' do
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

      it 'accepts the &block' do
        expect { create }.not_to raise_error
        expect(create.block_passed?).to be true
      end
    end

    context 'when the redacted_unsafe configuration property is true' do
      subject(:create) do
        described_class.create(**hash)
      end

      before do
        described_class.configure do |config|
          config.blacklist = blacklist
          config.whitelist = whitelist
          config.redacted_label = redacted_label
          config.redacted_unsafe = redacted_unsafe
        end
      end

      context 'when a blacklist is configured' do
        let(:blacklist) { %i[password email dob ssn] }
        let(:whitelist) { [] }
        let(:redacted_unsafe) { true }
        let(:redacted_label) { '[redacted]' }

        it_behaves_like 'there is private method access to blacklisted field values'
        it_behaves_like 'there is no private method access to blacklisted field values'
      end

      context 'when a whitelist is configured' do
        let(:blacklist) { [] }
        let(:whitelist) { %i[first last] }
        let(:redacted_unsafe) { true }
        let(:redacted_label) { '[redacted]' }

        it_behaves_like 'there is private method access to non-whitelisted field values'
        it_behaves_like 'there is no private method access to non-whitelisted field values'
      end
    end
  end

  describe '#create_with' do
    subject(:create_with) do
      described_class.create_with(config, **hash)
    end

    context 'when a blacklist is configured' do
      let(:config) do
        described_class::Configuration.new.tap do |config|
          config.blacklist = blacklist
          config.redacted_label = redacted_label
        end
      end
      let(:blacklist) { %i[first last] }
      let(:redacted_label) { 'x' }

      context 'with no blacklisted fields configured' do
        let(:blacklist) { [] }

        it 'does not redact any field values' do
          expect(create_with.first).to eq hash[:first]
          expect(create_with.last).to eq hash[:last]
          expect(create_with.password).to eq hash[:password]
          expect(create_with.ssn).to eq hash[:ssn]
          expect(create_with.dob).to eq hash[:dob]
        end
      end

      context 'with blacklist fields configured' do
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
    end

    context 'when a whitelist is configured' do
      let(:config) do
        described_class::Configuration.new.tap do |config|
          config.whitelist = whitelist
          config.redacted_label = redacted_label
        end
      end
      let(:redacted_label) { 'x' }

      context 'with no whitelisted fields configured' do
        let(:whitelist) { [] }

        it 'redacts password by default' do
          expect(create_with.password).to eq config.redacted_label
        end

        it 'does not redact any other field values' do
          expect(create_with.first).to eq hash[:first]
          expect(create_with.last).to eq hash[:last]
          expect(create_with.ssn).to eq hash[:ssn]
          expect(create_with.dob).to eq hash[:dob]
        end
      end

      context 'with whitelisted fields configured' do
        let(:whitelist) { %i[first last] }

        it 'redacts the correct field values' do
          expect(create_with.password).to eq config.redacted_label
          expect(create_with.ssn).to eq config.redacted_label
          expect(create_with.dob).to eq config.redacted_label
        end

        it 'does not redact non-redacted field values' do
          expect(create_with.first).to eq hash[:first]
          expect(create_with.last).to eq hash[:last]
        end
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
