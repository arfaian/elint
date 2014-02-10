class Expense < ActiveRecord::Base
  before_validation :convert_cost, :only => :cost

  private
    def convert_cost
      self.cost = self.cost.nil? ? 0 : Integer(cost * 100)
    end
end
