$ ->
  $input = $ '#answer'

  # Return x + n. If result is greater then 9 then return last digit.
  # Values of x and n should be from 0 to 9.
  increase10 = (x, n = 1) -> if x + n <= 9 then x + n else x + n - 10
  
  # Return x - n. If result is less then 0 then return addition up to 10.
  # Values of x and n should be from 0 to 9.
  decrease10 = (x, n = 1) -> if x - n >= 0 then x - n else 10 - n + x

  # Padlock code.
  code = {
    values: [0, 0, 0]
    # Increase value with index - idx.
    increase: (idx) ->
      @values[idx] = increase10 @values[idx]
      $input.val @values.join('')
      @values[idx]
    # Decrease value with index - idx.
    decrease: (idx) ->
      @values[idx] = decrease10 @values[idx]
      $input.val @values.join('')
      @values[idx]
  }

  # Remove notransition class from digits which shouldn't animated when moves up or down.
  removeNoTransition = ->
    noTransitionTimer = setTimeout ->
      $('.notransition').removeClass 'notransition'
    , 20

  # Move digits up.
  moveUp = ($parent) ->
    # Cacl new current value.
    n = code.decrease $parent.data('code-idx')
    # Calc new next value.
    nextN = decrease10 n
    # Calc new prev value.
    prevN = increase10 n
    # Remove current up event listener.
    $this = $parent.find("g.pdln-#{increase10(prevN)}").off 'click'
    # Add another up event listener.
    $prev = $parent.find("g.pdln-#{prevN}").click -> moveUp $(@parentElement)
    # Remove current down event listener.
    $current = $parent.find("g.pdln-#{n}").off 'click'
    # Add another down event listener.
    $next = $parent.find("g.pdln-#{nextN}").click -> moveDown $(@parentElement)
    # Rotate visible numbers up.
    $this.css 'transform', 'rotateX(72deg)'
    $prev.css('transform', 'rotateX(36deg)')
    $parent.find("g.pdln-#{n}").css 'transform', 'rotateX(0)'
    $next.css('transform', 'rotateX(-36deg)')
    # Move upper number to down.
    $parent.find("g.pdln-#{decrease10(nextN)}").addClass('notransition')
      .css 'transform', 'rotateX(-72deg)'
    removeNoTransition()

  $('g.pdln-1').click -> moveUp $(@parentElement)

  # Move digits down.
  moveDown = ($parent) ->
    # Increase code number.
    n = code.increase $parent.data('code-idx')
    nextN = decrease10 n
    prevN = increase10 n
    # Remove current down event listener.
    $this = $parent.find("g.pdln-#{decrease10(nextN)}").off 'click'
    # Add another down event listener.
    $next = $parent.find("g.pdln-#{nextN}").click -> moveDown $(@parentElement)
    # Remove current up event listener.
    $current = $parent.find("g.pdln-#{n}").off 'click'
    # Add another up event listener.
    $prev = $parent.find("g.pdln-#{prevN}").click -> moveUp $(@parentElement)
    # Rotate visible numbers down.
    $prev.css 'transform', 'rotateX(36deg)'
    $current.css 'transform', 'rotateX(0)'
    $next.css('transform', 'rotateX(-36deg)')
    $this.css('transform', 'rotateX(-72deg)')
    # Move buttom number to up.
    $parent.find("g.pdln-#{decrease10(nextN, 3)}").addClass('notransition')
      .css 'transform', 'rotateX(72deg)'
    removeNoTransition()

  $('g.pdln-9').click -> moveDown $(@parentElement)
  
  mouseStartY = null
  $('g.pdl').on 'mousedown touchstart', (event) ->
    if event.touches && event.touches.length == 1
      mouseStartY = event.touches[0].pageY
    else if event.which == 1
      mouseStartY = event.pageY

  $(document).on 'mouseup touchend', -> mouseStartY = null

  $('g[data-code-idx]').on 'mousemove touchmove', (event) ->
    event.preventDefault()
    if mouseStartY
      if event.touches && event.touches.length == 1
        mouseScrollY = mouseStartY - event.touches[0].pageY
      else
        mouseScrollY = mouseStartY -  event.pageY
      if mouseScrollY > 15
        mouseStartY -= 30
        moveUp($(@))
      else if mouseScrollY < -15
        mouseStartY += 30
        moveDown($(@))