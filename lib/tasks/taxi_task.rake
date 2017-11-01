namespace :taxi_task do
  task create_drivers: :environment do
    5.times do
      Driver.create
    end
  end
  task create_customers: :environment do
    20.times do
      Customer.create
    end
  end
end
