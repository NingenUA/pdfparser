class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :user
      t.string :servpp
      t.string :ala
      t.string :ldarc
      t.string :dvao
      t.string :otherf
      t.string :gst
      t.string :subtotal
      t.string :total
      t.integer :book_id

    end
  end
end
