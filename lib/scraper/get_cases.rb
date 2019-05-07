class Scraper
  def get_cases
    login
    goto_all_cases
    show_all_cases unless @debug # Get just 1 page
    fetch_cases
    puts "Scrape complete! #{@data.count} records found."
    @data
  end

  private

  def show_all_cases
    puts 'Fetching all cases. This may take a few minutes...'
    page_count = 1
    while @walker.has_css?('.moreCases')
      @walker.find('.moreCases').click
      sleep 1
      puts "Page #{page_count} fetched."
      page_count += 1
    end
    puts 'Cases Fetched!'
  end

  def goto_all_cases
    @walker.visit "#{ENV.fetch('ORTRAX_WEB_URL')}/all-cases/0"
    wait_until{ @walker.has_css?('.moreCases') }
  end

  def fetch_cases
    puts 'Parsing page data.'
    @walker.find_all('.mdl-cell').each do |cell|
      details = cell.find('.case-details')
      id = details['data-caseid']

      @data << {
        id: id,
        doctor_name: details.find('.doctor-name').text,
        hospital_name: details.find('.hospital-name').text,
        date: details.find('.date').text,
        time: details.find('.time').text,
        notes: details.find('.notesAndComments').text
      }
    end
  end
end
