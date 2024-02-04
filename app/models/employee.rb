class Employee < ApplicationRecord
  validates :employee_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :rating, presence: true
end