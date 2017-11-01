class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.belongs_to :driver, index: true
      t.belongs_to :customer, index: true
      t.string :location
      t.integer :status
      t.datetime :completed_at
      t.timestamps
    end
  end
end
