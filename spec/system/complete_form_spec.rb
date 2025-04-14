

require 'rails_helper'

RSpec.describe 'Complete the landing form', type: :feature do
  let(:download_dir) { '/tmp/downloads' }

  before do
    clear_downloads(download_dir) # Ensure the directory is clean before starting the test
    Capybara.register_driver :selenium do |app|
      prefs = {
        download: {
          default_directory: download_dir,
          prompt_for_download: false
        }
      }
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_preference(:download, prefs)
      options.add_preference('download.default_directory', download_dir)
      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end
    Capybara.current_driver = :selenium
  end

  after do
    Capybara.use_default_driver # Reset driver after the test
    FileUtils.rm_rf(Dir.glob("#{download_dir}/*")) # Clean up downloaded files
  end

  describe 'UON Year 1' do
    context 'when the PBL and CLIN are chosen' do
      it 'sends an ics file to the browser' do
        visit '/'

        select 'UON', from: 'uni_select'
        select '1', from: 'year_select'
        select 'MEDI1101A Callaghan & Central Coast - Timetable - 2025 - Week 1&2 for Canvas.xlsx',
               from: 'spreadsheet_select'
        select 'K', from: 'pbl_select'
        select '20', from: 'clin_select'

        click_on 'Submit'

        wait_for_download(download_dir) # Custom method to wait for the file to appear if needed
        ics_files = Dir.glob(File.join(download_dir, '*.ics'))
        expect(ics_files.length).to eq(1)
      end
    end
    context 'when no PBL or CLIN are chosen' do
      it 'sends an ics file to the browser' do
        visit '/'

        select 'UON', from: 'uni_select'
        select '1', from: 'year_select'
        select 'MEDI1101A Callaghan & Central Coast - Timetable - 2025 - Week 1&2 for Canvas.xlsx',
               from: 'spreadsheet_select'
        choose 'user_input_exclude_pbl_and_clin_false'

        click_on 'Submit'

        wait_for_download(download_dir) # Custom method to wait for the file to appear if needed
        ics_files = Dir.glob(File.join(download_dir, '*.ics'))
        expect(ics_files.length).to eq(1)
      end
    end
  end

  describe 'UON Year 2' do
    context 'when the PBL is chosen' do
      it 'sends an ics file to the browser' do
        visit '/'

        select 'UON', from: 'uni_select'
        select '2', from: 'year_select'
        select '2025 MEDI2101A Timetable - CANVAS-63e89cc6-7a4e-4f15-9284-c353d18b9f69.xlsx', from: 'spreadsheet_select'
        select 'K', from: 'pbl_select'

        click_on 'Submit'

        wait_for_download(download_dir) # Custom method to wait for the file to appear if needed
        ics_files = Dir.glob(File.join(download_dir, '*.ics'))
        expect(ics_files.length).to eq(1)
      end
    end
    context 'when no PBL or CLIN are chosen' do
      it 'sends an ics file to the browser' do
        visit '/'

        select 'UON', from: 'uni_select'
        select '2', from: 'year_select'
        select '2025 MEDI2101A Timetable - CANVAS-63e89cc6-7a4e-4f15-9284-c353d18b9f69.xlsx', from: 'spreadsheet_select'
        choose 'user_input_exclude_pbl_and_clin_false'

        click_on 'Submit'

        wait_for_download(download_dir) # Custom method to wait for the file to appear if needed
        ics_files = Dir.glob(File.join(download_dir, '*.ics'))
        expect(ics_files.length).to eq(1)
      end
    end
  end

  describe 'UNE Year 1' do
    context 'when the PBL and CLIN are chosen' do
      it 'sends an ics file to the browser' do
        visit '/'

        select 'UNE', from: 'uni_select'
        select '1', from: 'year_select'
        select 'UNE MEDI1101A Student Timetable Wk 2 - 14.xlsx', from: 'spreadsheet_select'
        select 'A', from: 'pbl_select'
        select '1', from: 'clin_select'

        click_on 'Submit'

        wait_for_download(download_dir) # Custom method to wait for the file to appear if needed
        ics_files = Dir.glob(File.join(download_dir, '*.ics'))
        expect(ics_files.length).to eq(1)
      end
    end
    context 'when no PBL or CLIN are chosen' do
      it 'sends an ics file to the browser' do
        visit '/'

        select 'UNE', from: 'uni_select'
        select '1', from: 'year_select'
        select 'UNE MEDI1101A Student Timetable Wk 2 - 14.xlsx', from: 'spreadsheet_select'
        choose 'user_input_exclude_pbl_and_clin_false'

        click_on 'Submit'

        wait_for_download(download_dir) # Custom method to wait for the file to appear if needed
        ics_files = Dir.glob(File.join(download_dir, '*.ics'))
        expect(ics_files.length).to eq(1)
      end
    end
  end
end

def clear_downloads(download_dir)
  FileUtils.mkdir_p(download_dir)
  FileUtils.rm_rf(Dir.glob("#{download_dir}/*"))
end

def wait_for_download(download_dir)
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until Dir.glob(File.join(download_dir, '*.ics')).any?
  end
end
