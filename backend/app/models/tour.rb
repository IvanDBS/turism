class Tour < ApplicationRecord
  has_many :bookings, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 2000 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :duration, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :destination, presence: true
  validates :category, presence: true, inclusion: { in: %w[beach mountain city cultural adventure luxury] }
  
  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_price_range, ->(min_price, max_price) { where(price: min_price..max_price) if min_price.present? && max_price.present? }
  scope :by_duration, ->(duration) { where(duration: duration) if duration.present? }
end
