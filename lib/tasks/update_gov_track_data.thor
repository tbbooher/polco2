class UpdateGovTrackData < Thor

  ENV['RAILS_ENV'] ||= 'development'
  # require "#{Rails.roo/config/environment.rb"
  require File.expand_path('config/environment.rb')

  desc "update_from_directory", "updates all bills from directory"
  def update_from_directory
    Dir.glob("#{Rails.root}/data/bills/*.xml").each do |bill_path|
      bill_name = bill_path.match(/.*\/(.*).xml$/)[1]
      puts "processing #{bill_name}"
      b = Bill.find_or_create_by(:title => bill_name, :govtrack_name => bill_name)
      b.update_bill
      b.save!
    end
  end

  desc "delete_all_member_votes", "deletes all member votes from all bills (DANGER!)"
  def delete_all_member_votes
    # use with caution
    Bill.all.to_a.each do |b|
      b.member_votes = []
      b.roll_time = nil
      b.save
    end
  end

  desc "pull_out", "pull out rolled bills"
  def pull_out
    pattern = /<bill session="(\d+)" type="(\w+)" number="(\d+)" \/>/
    bills = []
    Dir.glob("#{Rails.root}/data/rolls/*.xml").each do |file|
      File.open(file) do |f|
        f.each_line do |line|
          bills.push("#{$2}#{$3}.xml") if line.match(pattern)
        end
      end
    end
    puts bills.sort.uniq
  end

  desc "move_in_bills", "pull in relevant bills"
  def move_in_bills
     File.read("#{Rails.root}/spec/test_data/test_bills.txt").split("\n").each do |bill_name|
       FileUtils.copy("#{Rails.root}/data/bills/#{bill_name}","#{Rails.root}/data/select_bills/")
     end
     districts_array = File.new("#{Rails.root}/data/districts.txt", 'r').read.split("\n")
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
      the_bill.pull_in_role_feed(feed, govtrack_id)
    else
      puts "we don't need to look at #{File.basename(f)} with category #{feed.bill_category}"
    end # bill check
  end

  no_tasks do

    def we_need_to_look_at_it(feed, govtrack_id)
      #t = Time.parse(feed.updated_time)
      # we need to look at it if the bill is of category 'passage' and we haven't already looked at it
      #if feed.bill_category == 'passage'
        puts "hier #{govtrack_id}"
        Bill.where(govtrack_id: govtrack_id).first
      #else
      #  nil
      #end
    end
  end

end
