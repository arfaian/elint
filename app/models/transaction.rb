require_relative '../../lib/api/transaction'

class Transaction < ActiveRecord::Base
  include API::Transaction

  after_initialize :after_initialize
  validates_presence_of :sum, :merchant, :date
  belongs_to :user
  acts_as_taggable
  classy_enum_attr :transaction_type
  monetize :sum_cents

  scope :current_month, -> { where("date > ? AND date < ?",
      Date.today.beginning_of_month, Date.today.end_of_month) }

  scope :credits, -> { where transaction_type: :credit }
  scope :debits, -> { where transaction_type: :debit }

  private
    def after_initialize
      self.transaction_type = :debit if new_record?
      self.date ||= Date.today if new_record?
    end
end
