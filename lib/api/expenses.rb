module API
  class Expenses
    def initialize(user)
      @user = user
    end

    def costs
      @costs ||= begin
        @user.expenses.current_month.select(:cost_cents).map(&:cost_cents)
        number_to_currency(costs.reduce(:+) / 100.0, precision: 2)
      end
    end

    def income
      @user.credits.current_month
    end

    def saved
      @user.monthly_income - costs
    end
  end
end
