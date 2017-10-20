$ ->
  # Delete card
  cardsContainer = $ '#cards-container'

  # Perform operation on card (delete or set default)
  cardOp = (target, url)->
    target.disabled = true
    $.post url, card_id: target.parentNode.getAttribute('data-card-id'),
      (response)->
        target.disabled = false
        cardsContainer.html response

  cardsContainer.on 'click', '.delete-card-btn', (event)->
    cardOp event.target, '/subscriptions/delete_card'

  cardsContainer.on 'click', '.set-default-btn', (event)->
    cardOp event.target, '/subscriptions/set_default'
