class Customer < ApplicationRecord
  has_many :requests
  has_many :drivers, through: :requests
end
