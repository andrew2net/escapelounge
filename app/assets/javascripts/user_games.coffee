$ ->
  hintsContainer = $ '#hints-container'

  # Show hint and reduce remaning time on click the button.
  hintsContainer.on 'click', '#show-hint-btn', (event)->
    hint_id = event.target.getAttribute 'data-hint-id'
    value = parseInt(event.target.getAttribute('data-value'))
    window.timer.secondsRemain -= value
    url = event.target.getAttribute 'data-url'
    hintsContainer.load url, { hint_id: hint_id }
