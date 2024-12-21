class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :dob, :date
    add_column :users, :role, :integer, default: 2
  end
end
