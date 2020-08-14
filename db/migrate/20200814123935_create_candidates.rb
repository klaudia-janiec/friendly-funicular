class CreateCandidates < ActiveRecord::Migration[6.0]
  def change
    create_table :candidates do |t|
      t.string :uid, null: false
      t.string :forename, null: false
      t.string :surname, null: false
      t.string :state, null: false
    end

    add_index :candidates, %i[forename surname]
  end
end
