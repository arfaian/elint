class Expense < ActiveRecord::Base
  before_validation :convert_cost, :only => :cost
  acts_as_taggable

  private
    def convert_cost
Rails.logger.info self.cost
      self.cost = self.cost.nil? ? 0 : Integer(cost * 100)
    end
end
