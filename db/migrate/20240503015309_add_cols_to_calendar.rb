

class AddColsToCalendar < ActiveRecord::Migration[7.0]
  def change
    add_column :calendars, :pbl, :string
    add_column :calendars, :clin, :string
    add_column :calendars, :year, :string
    add_column :calendars, :uni, :string
    add_column :calendars, :spreadsheet, :string
  end
end
