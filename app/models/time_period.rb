class TimePeriod
  attr_reader :start_date, :end_date
  def initialize(start_date, end_date)
    @start_date = start_date.to_date
    @end_date   = end_date  .to_date
  end
  
  ##### NOTE: Obviously, this depends on your payroll/billing cycle.
  # For a given date, return the beginning and end dates for the pay period.
  def self.boundaries_for(date)
    raise "Subclass responsibility!"
  end
  
  ##### Class constructors
  def self.for_date(date)
    new(*boundaries_for(date))
  end
  def self.current
    for_date(Date.today)
  end
  def self.last_but(n)   # NB:  O(n) performance, so try not to get the 50,325th one, mmkay?
    pp = current
    (n + 1).times { pp = pp.prev }
    pp
  end

  ##### Instance methods
  def boundaries
    [start_date, end_date]
  end

  def prev
    self.class.for_date(start_date - 1)
  end
  def next
    self.class.for_date(end_date + 1)
  end

  def to_s
    show_month = true
    show_dates = start_date != start_date.beginning_of_month || end_date != end_date.end_of_month
    show_year  = start_date.year != Date.today.year
    returning('') do |s|
      s << start_date.strftime('%b ') if show_month
      s << "%d" % [start_date.day]    if show_dates
      s << '-'
      s << end_date.strftime('%b ')   if show_month && start_date.month != end_date.month
      s << "%d" % [end_date.day]     if show_dates
      s << ','                        if show_dates && show_year
      s << " #{start_date.year}"      if show_year
    end
  end
  def inspect
    '#<%s:%s  [%s] >' % [self.class.name, hash, to_s]
  end

end
