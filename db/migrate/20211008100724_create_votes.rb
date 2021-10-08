class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.boolean :promote, default: false
      t.belongs_to :user
      t.belongs_to :voteable, polymorphic: true

      t.timestamps
    end
  end
end
