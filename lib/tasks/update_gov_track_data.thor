class UpdateGovTrackData < Thor

  ENV['RAILS_ENV'] ||= 'development'
  # require "#{Rails.roo/config/environment.rb"
  require File.expand_path('config/environment.rb')

  desc "load_legislators", "loads all members"
  def load_legislators
    Legislator.update_legislators
  end

  desc "update_from_directory", "updates all bills from directory"
  def update_from_directory
    Dir.glob("#{DATA_PATH}/bills/*.xml").each do |bill_path|
      bill_name = bill_path.match(/.*\/(.*).xml$/)[1]
      puts "processing #{bill_name}"
      b = Bill.find_or_create_by(:title => bill_name, :govtrack_name => bill_name)
      b.update_bill
      b.save!
    end
  end

  desc "pull_out", "pull out rolled bills"
  def pull_out
    pattern = /<bill session="(\d+)" type="(\w+)" number="(\d+)" \/>/
    count = 0
    Dir.glob("#{Rails.root}/data/rolls/*.xml").each do |file|
      File.open(file) do |f|
        f.each_line do |line|
          if line.match(pattern) && count < 100
            count = count + 1
            bill_type = $2
            number = $3   # NOT
            bill_name = "#{bill_type}#{number}.xml"
            # Bill files are named as follows: data/us/CCC/rolls/TTTNNN.xml.
            # TTT = type of resolution
            # NNN = bill number with zero padding
            FileUtils.copy(file,"#{Rails.root}/spec/test_data/rolls/")
            FileUtils.copy("#{Rails.root}/data/bills/#{bill_name}","#{Rails.root}/spec/test_data/bills/")
          end
        end
      end
    end
  end

  desc "update_rolls", "update the rolls of all bills"
  def update_rolls
    Dir.glob("#{DATA_PATH}/rolls/*.xml").sort_by { |f| f.match(/\/.+\-(\d+)\./)[1].to_i }.each do |bill_path|
      process_roll(bill_path)
    end
  end

  desc "process_roll", "update an individual role give a path to an xml file"
  def process_roll(path)
    f = File.new(path, 'r')
    feed = Feedzirra::Parser::RollCall.parse(f)
    govtrack_id = "#{feed.bill_type}#{feed.congress}-#{feed.bill_number}"
    if the_bill = Bill.where(govtrack_id: govtrack_id).first # we_need_to_look_at_it(feed, govtrack_id)
      puts "Processing #{File.basename(f)} for #{govtrack_id}"
      Roll.pull_in_role_feed(feed, govtrack_id, the_bill)
    else
      puts "we don't need to look at #{File.basename(f)} with category #{feed.bill_category}"
    end # bill check
  end

end
