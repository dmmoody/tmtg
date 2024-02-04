class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees, id: :uuid do |t|
      t.uuid :employee_id, null: false, index: { unique: true }
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :phone
      t.date :date_of_birth
      t.string :address
      t.string :country
      t.string :bio, array: true, default: []
      t.float :rating, null: false, default: 0.00, precision: 3, scale: 2

      t.timestamps
    end
  end
end