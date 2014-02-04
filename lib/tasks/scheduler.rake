desc "This task is called by the Heroku scheduler add-on"

task :find_todays_costs => :environment do
  CostFinder.new.find.each do |cost|
    cost.tracking_link.generate_expense_records
  end
end
