$ ->
  # Delete card
  $(document).on 'click', '.delete-card-btn', (event)->
    event.target.disabled = true
    $.post '/subscriptions/delete_card',
      card_id: event.target.getAttribute('data-card-id'),
      -> event.target.disabled = false
