class AddUrlField < ActiveRecord::Migration
  def change
    add_column :videos, :url, :text
  end
end
