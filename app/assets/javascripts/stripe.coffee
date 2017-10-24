$ ->
  # Return if there isn't card element on page
  return unless document.getElementById 'card-element'
  # Create a Stripe client
  stripe = Stripe 'pk_test_aEl2kU2mLmlQyBR4fYbZLNJ8'

  # Create an instance of Elements
  elements = stripe.elements()

  # Custom styling can be passed to options when creating an Element
  style =
    base:
      color: '#32325d'
      lineHeight: '24px'
      fontFamily: '"Helvetica Neue", Helvetica, sans-serif'
      fontSmoothing: 'antialiased'
      fontSize: '16px'
      '::placeholder':
        color: '#aab7c4'

    invalid:
      color: '#fa755a',
      iconColor: '#fa755a'

  # Create an instance of the card Element
  card = elements.create 'card', style: style

  # Add an instance of the card Element into the `card-element` <div>
  card.mount '#card-element'

  # Handle real-time validation errors from the card Element
  card.addEventListener('change', (event)->
    displayError = document.getElementById 'card-errors'
    if event.error
      displayError.textContent = event.error.message
     else
      displayError.textContent = ''
  )

  cardsContainer = $ '#cards-container'

  # Handle form submission
  form = document.getElementById 'payment-form'
  form.addEventListener('submit', (event)->
    event.preventDefault()
    btn = event.target.getElementsByTagName('button')[0]
    btn.disabled = true

    stripe.createToken(card).then((result)->
      if result.error
        # Inform the user if there was an error
        errorElement = document.getElementById 'card-errors'
        errorElement.textContent = result.error.message
        btn.disabled = false
      else
        # Send the token to your server
        $.post form.action, result.token, (res)->
          if res && cardsContainer
            cardsContainer.html res
            btn.disabled = false
            card.clear()
          else
            window.location = '/subscriptions/billing'
    )
  )
