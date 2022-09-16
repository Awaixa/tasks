require 'rails_helper'

RSpec.describe TaskReminder do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to_not allow_value('a' * 101).for(:description) }
    it { is_expected.to allow_value('a' * 100).for(:description) }
    it { is_expected.to allow_value('a').for(:description) }

    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:end_at) }

    it { is_expected.to validate_presence_of(:off_set) }
    it { is_expected.to_not allow_value('a').for(:off_set) }
    it { is_expected.to allow_value('1').for(:off_set) }
    it { is_expected.to allow_value(12).for(:off_set) }
  end

  describe 'creation' do
    subject(:task_reminder) { described_class.new(attributes) }

    context 'when invalid attributes are provided' do
      context 'when empty attributes' do
        let(:attributes) { {} }

        it 'returns an errors' do
          expect(task_reminder.save).to be_falsy
          expect(task_reminder.errors.any?).to be_truthy
          expect(task_reminder.errors.messages).to eq(
            {
              task:        ["must exist"],
              description: ["can't be blank"],
            }
          )
        end
      end
    end

    context 'when valid attributes are provided' do
      let(:task) { FactoryBot.create :task }
      let(:attributes) { {description: 'You should clean your bedroom', task: task} }

      it { expect { task_reminder.save }.to change(described_class, :count).by(1) }
      it { expect(task_reminder.uuid).to be_present }
      it { expect(task_reminder.off_set).to eq 1440 }
      it { expect(task_reminder.start_at).to be_present }
      it { expect(task_reminder.end_at).to be_present }
      it { expect(task_reminder.sleep_mode).to eq false }
      it { expect(task_reminder.task).to be_present }
    end
  end
end
