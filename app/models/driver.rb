class Driver < ApplicationRecord
  has_many :requests
  has_many :customers, through: :requests

  def ongoing_requests
    requests.ongoing
  end

  def completed_requests
    requests.completed
  end
end
