class FavoriteTour < ApplicationRecord
  belongs_to :user
  belongs_to :tour
  
  validates :user_id, uniqueness: { scope: :tour_id }
  
  scope :recent, -> { order(created_at: :desc) }
end
