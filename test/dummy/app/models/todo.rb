class Todo < ApplicationRecord
  PRIORITIES = %w[low medium high].freeze

  validates :title, presence: true, length: {minimum: 3}, uniqueness: true
  validates :priority, presence: true, inclusion: {in: PRIORITIES}
end
