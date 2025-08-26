class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :role, :created_at
  
  has_many :bookings
end
