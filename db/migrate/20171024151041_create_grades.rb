class CreateGrades < ActiveRecord::Migration[5.1]
  def change
    create_table :grades do |t|
      t.string :name

      t.timestamps
    end

    Grade.create name: "ages 5-9"
    Grade.create name: "ages 10-14"
    Grade.create name: "ages 15-19"

    create_join_table :games, :grades do |t|
      t.index :game_id
      t.index :grade_id
    end

    create_join_table :grades, :subscription_plans do |t|
      t.index :grade_id
      t.index :subscription_plan_id
    end

    reversible do |dir|
      dir.up  do
        Game.all.each do |game|
          grade = Grade.find game.age_range + 1
          game.grades << grade
        end
      end
    end

    remove_column :games, :age_range, :integer
  end
end
