class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :uuid, null: false, index: {unique: true}
      t.string :name
      t.string :description
      t.string :category
      t.integer :priority

      t.timestamps
    end

    create_table :task_reminders do |r|
      r.string :uuid, null: false, index: {unique: true}
      r.string :description
      r.datetime :start_at
      r.datetime :end_at
      r.boolean :sleep_mode
      r.integer :off_set

      r.references :task, null: false, foreign_key: true

      r.timestamps
    end
  end
end
