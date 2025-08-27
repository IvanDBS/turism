class Notification < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :message, presence: true
  validates :notification_type, presence: true, inclusion: { 
    in: %w[booking_confirmed booking_cancelled payment_received tour_reminder system_announcement] 
  }
  
  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  
  def read?
    read_at.present?
  end
  
  def mark_as_read!
    update!(read_at: Time.current)
  end
  
  def self.create_for_user(user, title, message, notification_type = 'system_announcement', metadata = {})
    create!(
      user: user,
      title: title,
      message: message,
      notification_type: notification_type,
      metadata: metadata
    )
  end
end
