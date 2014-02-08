class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :client_num
      t.string :bill_num
      t.timestamps
    end
  end
end
