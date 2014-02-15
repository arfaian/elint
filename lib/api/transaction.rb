module API
  module Transaction

    def self.included receiver
      receiver.extend ClassMethods
    end

    module ClassMethods
      def debits_sum(user)
        int_to_currency(user.transactions.current_month.debits)
      end

      def credits_sum(user)
        int_to_currency(user.transactions.current_month.credits)
      end

      private
        def int_to_currency(transactions)
          sum = transactions.select(:sum_cents).map(&:sum_cents).reduce(:+)
          Money.new(sum, 'USD').to_s
        end
    end

  end
end
