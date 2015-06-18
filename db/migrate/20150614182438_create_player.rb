class CreatePlayer < ActiveRecord::Migration
  def up
    create_table :players do |t|
      t.string :name
    end
  end

  def down
    drop_table :players
  end
end