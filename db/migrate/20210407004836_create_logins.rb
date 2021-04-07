class CreateLogins < ActiveRecord::Migration[6.0]
  def change
    create_table :logins do |t|
      t.uuid :token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
