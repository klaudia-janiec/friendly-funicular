class AddMeetingsToCandidate < ActiveRecord::Migration[6.0]
  def change
    add_column :candidates, :meetings, :string
  end
end
