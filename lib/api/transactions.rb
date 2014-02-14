module API
  class Transactions
    def initialize(user)
      @user = user
    end

    def debits
      @debits ||= int_to_currency(@user.transactions.current_month.debits)
    end

    def credits
      @credits ||= int_to_currency(@user.transactions.current_month.credits)
    end

    def int_to_currency(transactions)
      sum = transactions.select(:sum_cents).map(&:sum_cents)
      number_to_currency(sum.reduce(:+) / 100.0, precision: 2)
    end

    def saved
      debits - credits
    end
  end
end
