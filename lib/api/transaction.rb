module API
  module Transaction

    def self.included receiver
      receiver.extend ClassMethods
    end

    module ClassMethods
      def debits_amount(user)
        int_to_currency(user.transactions.current_month.debits)
      end

      def credits_amount(user)
        int_to_currency(user.transactions.current_month.credits)
      end

      private
        def int_to_currency(transactions)
          amount = transactions.select(:amount_cents).map(&:amount_cents).reduce(:+)
          Money.new(amount, 'USD').to_s
        end
    end

  end
end
