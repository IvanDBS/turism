class BookingSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :guests, :total_price, :status, :created_at
  
  belongs_to :user
  belongs_to :tour
end
