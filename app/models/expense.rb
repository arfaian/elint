class Expense < ActiveRecord::Base
  after_initialize :after_initialize
  validates_presence_of :cost, :merchant, :date
  belongs_to :user
  acts_as_taggable
  monetize :cost_cents

  scope :current_month, -> { where("date > ? AND date < ?",
      Date.today.beginning_of_month, Date.today.end_of_month) }

  private
    def after_initialize
      self.date ||= Date.today if new_record?
    end
end
