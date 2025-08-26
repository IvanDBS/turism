class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :tour
  
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :guests, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 20 }
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending confirmed cancelled completed] }
  
  validate :end_date_after_start_date
  validate :start_date_in_future
  
  before_validation :calculate_total_price, on: :create
  before_validation :set_default_status, on: :create
  
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :upcoming, -> { where('start_date >= ?', Date.current) }
  scope :past, -> { where('end_date < ?', Date.current) }
  
  private
  
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    
    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end
  
  def start_date_in_future
    return if start_date.blank?
    
    if start_date < Date.current
      errors.add(:start_date, "must be in the future")
    end
  end
  
  def calculate_total_price
    return unless tour && guests
    
    self.total_price = tour.price * guests
  end
  
  def set_default_status
    self.status ||= 'pending'
  end
end
