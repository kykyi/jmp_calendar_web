# frozen_string_literal: true

class CreateCalendars < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :calendars do |t|
      t.string :raw, null: false
      t.timestamps
    end
  end
end
