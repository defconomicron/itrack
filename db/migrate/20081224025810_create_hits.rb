class CreateHits < ActiveRecord::Migration
  def self.up
    create_table :hits do |t|
      t.string  :domain
      t.string  :url
      t.string  :ip_address
      t.string  :cookie_id
      t.string  :country
      t.string  :region
      t.string  :city
      t.string  :longitude
      t.string  :latitude
      t.boolean :new_visitor
      t.boolean :new_visit
      t.string  :http_user_agent
      t.string  :http_accept_language

      t.timestamps
    end
  end

  def self.down
    drop_table :hits
  end
end
