require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'recurring.transactions.job', at: '06:00') { RecurringTransactionsJob.new.perform }
end
