module ApplicationHelper
  def format_date_time(date_time)
    date_time.strftime("%B %d, %Y - %I:%M%P")
  end
end
