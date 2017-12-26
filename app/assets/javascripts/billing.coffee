$ ->
  $cardsContainer = $ '#cards-container'
  $changePlanBtn = $ '#change-plan-btn'
  $subscriptionPlan = $ '#change-subscribe-form select'
  $cancelSubscriptionBtn = $ '#cancel-subscription-btn'
  $subscriptionCanceledWarn = $ '#subscription-canceled-warn'
  $subscriptionWillCancelWarn = $ '#subscription-will-cancel-warn'

  # Perform operation on card (delete or set default)
  cardOp = (target, url)->
    target.disabled = true
    $.post url, card_id: target.parentNode.getAttribute('data-card-id'),
      (response)->
        target.disabled = false
        $cardsContainer.html response

  $cardsContainer.on 'click', '.delete-card-btn', (event)->
    cardOp @, '/subscriptions/delete_card'

  $cardsContainer.on 'click', '.set-default-btn', (event)->
    cardOp @, '/subscriptions/set_default'

  $changePlanBtn.click (event)->
    @disabled = true
    $.post "/subscriptions/#{$subscriptionPlan.val()}/subscribe", ->
      event.target.setAttribute 'data-current-plan', $subscriptionPlan.val()
      $cancelSubscriptionBtn.prop 'disabled', false
      $subscriptionWillCancelWarn.addClass 'd-none'

  # On subscription select
  $subscriptionPlan.change (event)->
    pristine = @value.length == 0 ||
      @value == $changePlanBtn.attr('data-current-plan') &&
      $subscriptionWillCancelWarn.hasClass 'd-none'
    $changePlanBtn.prop('disabled', pristine)

  $cancelSubscriptionBtn.click (event)->
    event.target.disabled = true
    $.post "/subscriptions/unsubscribe", ->
      $subscriptionWillCancelWarn.removeClass 'd-none'
      $changePlanBtn.prop 'disabled', false

  # Disbale subscribe button if subscription plan not selected.
  $changePlanBtn.attr 'disabled', true unless $subscriptionPlan.val()
