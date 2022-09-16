require 'rails_helper'

RSpec.describe Task do
  describe 'validations' do
    it { is_expected.to_not allow_value('a' * 51).for(:name) }
    it { is_expected.to allow_value('a' * 50).for(:name) }
    it { is_expected.to allow_value('a').for(:name) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to_not allow_value('a' * 101).for(:description) }
    it { is_expected.to allow_value('a' * 100).for(:description) }
    it { is_expected.to allow_value('a').for(:description) }
  end

  describe 'creation' do
    subject(:task) { described_class.new(attributes) }

    context 'when invalid attributes are provided' do
      let(:attributes) { {} }

      it 'returns an errors' do
        expect(task.save).to be_falsy
        expect(task.errors.any?).to be_truthy
        expect(task.errors.messages).to eq(
          {
            description: ["can't be blank"],
            name:        ["can't be blank"],
          }
        )
      end
    end

    context 'when valid attributes are provided' do
      let(:attributes) { {name: 'Clean Bedroom', description: 'Clean your bedroom'} }

      it { expect { task.save }.to change(described_class, :count).by(1) }
      it { expect(task.uuid).to be_present }
    end
  end
end
