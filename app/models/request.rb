class Request < ApplicationRecord
  belongs_to :driver, optional: true
  belongs_to :customer

  REQUEST_STATUS = [["Waiting", 0], ["Ongoing", 1], ["Completed", 2]]

  validates :customer_id, :location, presence: true
  validates :customer_id, inclusion: {in: Customer.select(:id).map(&:id), message: "not an accepted value"}
  validates :driver_id, inclusion: {in: Driver.select(:id).map(&:id), message: "not an accepted value"}, unless: :driver_blank?

  scope :waiting, -> {where status: Request::REQUEST_STATUS[0][1]}
  scope :ongoing, -> {where status: Request::REQUEST_STATUS[1][1]}
  scope :completed, -> {where status: Request::REQUEST_STATUS[2][1]}

  def is_ongoing?
    status == Request::REQUEST_STATUS[1][1]
  end

  def driver_blank?
    driver_id.blank?
  end

  def time_elapsed
    Time.now.utc - self.created_at
  end

  def status_name
    return Request::REQUEST_STATUS[0][0] if status == Request::REQUEST_STATUS[0][1]
    return Request::REQUEST_STATUS[1][0] if status == Request::REQUEST_STATUS[1][1]
    return Request::REQUEST_STATUS[2][0] if status == Request::REQUEST_STATUS[2][1]
  end

  after_create :set_status

  private

  def set_status
    self.update_column(:status, Request::REQUEST_STATUS[0][1])
  end
end
