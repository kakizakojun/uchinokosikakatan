class CreateMediaTags < ActiveRecord::Migration[6.1]
  def change
    create_table :media_tags do |t|
      t.string :key
      t.references :tag
      t.timestamps
    end
  end
end
