class Task < ApplicationRecord
  include WithUuid

  has_one :tasks_reminder, dependent: :destroy

  validates :description, presence: true, length: {maximum: 100}
  validates :name,        presence: true, length: {maximum: 50}, uniqueness: true
end
