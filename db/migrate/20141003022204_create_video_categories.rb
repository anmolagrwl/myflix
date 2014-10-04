class CreateVideoCategories < ActiveRecord::Migration
  def change
    create_table :video_categories do |t|
      t.column :video_id, :integer
      t.column :category_id, :integer
    end
  end
end
