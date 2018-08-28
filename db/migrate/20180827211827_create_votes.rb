class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true, index: true
      t.integer :value, default: 0, null: false

      t.timestamps
    end
  end
end
