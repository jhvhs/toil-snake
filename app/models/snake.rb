class Snake < ApplicationRecord
  has_many :scales, dependent: :delete_all
end
