class TaskReminder < ApplicationRecord
  include WithUuid

  belongs_to :task

  validates :description, presence: true, length: {maximum: 100}
  validates :start_at,    presence: true
  validates :end_at,      presence: true
  validates :off_set,     presence: true, numericality: true

  after_initialize :prefill_data

  private

  def prefill_data
    self.sleep_mode = false
    self.off_set = 1440
    self.start_at = DateTime.now
    self.end_at = DateTime.now + 1.day
  end
end
