class RecurrenceInterval < ClassyEnum::Base
end

class RecurrenceInterval::Daily < RecurrenceInterval
  def date
    1.day.from_now.to_date
  end
end

class RecurrenceInterval::Weekly < RecurrenceInterval
  def date
    1.week.from_now.to_date
  end
end

class RecurrenceInterval::Biweekly < RecurrenceInterval
  def date
    2.weeks.from_now.to_date
  end
end

class RecurrenceInterval::Monthly < RecurrenceInterval
  def date
    1.month.from_now.to_date
  end
end

class RecurrenceInterval::Bimonthly < RecurrenceInterval
  def date
    2.months.from_now.to_date
  end
end

class RecurrenceInterval::Semianually < RecurrenceInterval
  def date
    6.months.from_now.to_date
  end
end

class RecurrenceInterval::Anually < RecurrenceInterval
  def date
    1.year.from_now.to_date
  end
end
