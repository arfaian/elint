class Expense < ActiveRecord::Base
  after_initialize :after_initialize
  validates_presence_of :cost, :merchant, :date
  acts_as_taggable
  monetize :cost_cents

  private
    def after_initialize
      self.date ||= Date.today if new_record?
    end
end
