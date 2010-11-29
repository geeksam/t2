class HalfMonth < TimePeriod
  def self.boundaries_for(date)
    date  = date.to_date
    first = date.beginning_of_month
    last  = date.end_of_month
    case date.day
    when 1..15:   [first,       first + 14]
    else          [first + 15,  last      ]
    end
  end
end
