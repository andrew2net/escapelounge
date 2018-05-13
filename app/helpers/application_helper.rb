# frozen_string_literal: true

# Application helper.
module ApplicationHelper
  def format_date_time(date_time)
    date_time&.strftime('%B %d, %Y - %I:%M%P')
  end
end
