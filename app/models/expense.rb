class Expense < ActiveRecord::Base
  validates_presence_of :cost, :merchant, :date
  before_validation :convert_cost, :only => :cost
  acts_as_taggable

  private
    def convert_cost
      self.cost = self.cost.nil? ? 0 : Integer(cost * 100)
    end
end
