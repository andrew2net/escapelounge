$ ->
  hintsContainer = $ '#hints-container'
  # showHintBtn = $ '#show-hint-btn'

  hintsContainer.on 'click', '#show-hint-btn', (event)->
    hint_id = event.target.getAttribute 'data-hint-id'
    url = event.target.getAttribute 'data-url'
    hintsContainer.load url, { hint_id: hint_id }
