require_relative '../../lib/api/transaction'

class Transaction < ActiveRecord::Base
  include API::Transaction

  after_initialize :after_initialize
  validates_presence_of :sum, :merchant, :date
  validates :recurrence_interval, presence: true, if: :recurring?
  belongs_to :user
  acts_as_taggable
  classy_enum_attr :transaction_type, default: 'debit'
  classy_enum_attr :recurrence_interval, allow_nil: true
  monetize :sum_cents

  scope :current_month, -> { where(date: Date.today.beginning_of_month..Date.today.end_of_month) }

  scope :credits, -> { where transaction_type: :credit }
  scope :debits, -> { where transaction_type: :debit }
  scope :avoidable, -> { where avoidable: true }
  scope :recurring_today, -> { where recurrence_date: Date.today }

  private
    def after_initialize
      self.recurrence_date ||= self.recurrence_interval.date if new_record? && recurring?
      self.date ||= Date.today if new_record?
    end
end
