require 'rails_helper'

RSpec.describe Employee, type: :model do
  it { should have_db_column(:employee_id).of_type(:uuid).with_options(null: false)}
  it { should have_db_column(:first_name).of_type(:string).with_options(null: false)}
  it { should have_db_column(:last_name).of_type(:string).with_options(null: false)}
  it { should have_db_column(:email).of_type(:string)}
  it { should have_db_column(:phone).of_type(:string) }
  it { should have_db_column(:date_of_birth).of_type(:date) }
  it { should have_db_column(:address).of_type(:string) }
  it { should have_db_column(:country).of_type(:string) }
  it { should have_db_column(:bio).of_type(:string).with_options(array: true, default: [])}
  it { should have_db_column(:rating).of_type(:float).with_options(null: false)}
  it { should validate_presence_of(:employee_id) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:rating)}
end