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

  changePlanBtn = $ '#change-plan-btn'
  subscriptionPlan = $ '#change-subscribe-form select'
  cancelSubscriptionBtn = $ '#cancel-subscription-btn'
  subscriptionCanceledWarn = $ '#subscription-canceled-warn'

  changePlanBtn.click (event)->
    event.target.disabled = true
    $.post "/subscriptions/#{subscriptionPlan.val()}/subscribe", ->
      event.target.setAttribute 'data-current-plan', subscriptionPlan.val()
      cancelSubscriptionBtn.prop 'disabled', false
      subscriptionCanceledWarn.addClass 'd-none'

  subscriptionPlan.change (event)->
    pristine = event.target.value.length == 0 ||
      event.target.value == changePlanBtn.attr('data-current-plan') &&
      subscriptionCanceledWarn.hasClass 'd-none'
    changePlanBtn.prop('disabled', pristine)

  cancelSubscriptionBtn.click (event)->
    event.target.disabled = true
    $.post "/subscriptions/unsubscribe", ->
      subscriptionCanceledWarn.removeClass 'd-none'
      changePlanBtn.prop 'disabled', false
