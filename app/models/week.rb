class Week < TimePeriod
  def self.boundaries_for(date)
    date  = date.to_date
    first = date.beginning_of_week - 1 # week is monday-sunday, apparently
    last  = date.end_of_week       - 1 # week is monday-sunday, apparently
    [first, last]
  end
end
