class TransactionType < ClassyEnum::Base
end

class TransactionType::Credit < TransactionType
end

class TransactionType::Debit < TransactionType
end
