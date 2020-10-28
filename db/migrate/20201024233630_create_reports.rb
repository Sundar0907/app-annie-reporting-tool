class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.date :date
      t.string :country
      t.string :platform
      t.string :app
      t.string :connection
      t.float :ad_revenue
      t.float :impressions
      t.float :cpm
      
      t.timestamps
    end
  end
end
