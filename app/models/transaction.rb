require_relative '../../lib/api/transaction'

class Transaction < ActiveRecord::Base
  include API::Transaction

  after_initialize :after_initialize
  validates_presence_of :amount, :merchant, :date
  validates :recurrence_interval, presence: true, if: :recurring?
  belongs_to :user
  acts_as_taggable_on :tags, :categories
  classy_enum_attr :transaction_type, default: 'debit'
  classy_enum_attr :recurrence_interval, allow_nil: true
  monetize :amount_cents

  scope :current_month, -> { where(date: Date.today.beginning_of_month..Date.today.end_of_month) }
  scope :by_year, ->(date) { where(date: date.beginning_of_year..date.end_of_year) }
  scope :by_month, ->(date) { where(date: date.beginning_of_month..date.end_of_month) }
  scope :by_category, ->(categories) { tagged_with(categories, on: :categories) }

  scope :credits, -> { where transaction_type: :credit }
  scope :debits, -> { where transaction_type: :debit }
  scope :avoidable, -> { where avoidable: true }
  scope :recurring_today, -> { where recurrence_date: Date.today }

  def update_tags_and_categories(user)
    user.tag(self, with: self.tag_list, on: :tags)
    user.tag(self, with: self.category_list, on: :categories)
  end

  private
    def after_initialize
      self.recurrence_date ||= self.recurrence_interval.date if new_record? && recurring?
      self.date ||= Date.today if new_record?
    end
end
