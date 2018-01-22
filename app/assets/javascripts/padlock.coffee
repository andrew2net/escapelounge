$ ->
  $input = $ '#padlock_code'

  increase10 = (x, n = 1) -> if x + n <= 9 then x + n else x + n - 10
  decrease10 = (x, n = 1) -> if x - n >= 0 then x - n else 10 - n + x

  code = {
    values: [0, 0, 0]
    increase: (idx) ->
      @values[idx] = increase10 @values[idx]
      $input.val @values.join('')
      @values[idx]
    decrease: (idx) ->
      @values[idx] = decrease10 @values[idx]
      $input.val @values.join('')
      @values[idx]
  }

  noTransitionTimer = null
  removeNoTransition = ->
    clearTimeOut(noTransitionTimer) if noTransitionTimer
    noTransitionTimer = setTimeout ->
      $('.notransition').removeClass 'notransition'
      noTransitionTimer = null
    , 100

  moveUp = ->
    # Get index of number.
    codeIdx = parseInt @parentElement.id.match(/\d$/)[0]
    # Cacl new current value.
    n = code.decrease codeIdx
    # Calc new next value.
    nextN = decrease10 n
    # Calc new prev value.
    prevN = increase10 n
    # Remove current up event listener.
    $this = $(@).off 'click'
    $parent = $ @parentElement
    # Add another up event listener.
    $prev = $parent.find("g.pdln-#{prevN}").click moveUp
    # Remove current down event listener.
    $current = $parent.find("g.pdln-#{n}").off 'click'
    # Add another down event listener.
    $next = $parent.find("g.pdln-#{nextN}").click moveDown
    # Rotate visible numbers up.
    $this.css 'transform', 'rotateX(72deg)'
    $prev.css('transform', 'rotateX(36deg)')
    $parent.find("g.pdln-#{n}").css 'transform', 'rotateX(0)'
    $next.css('transform', 'rotateX(-36deg)')
    # Move upper number to down.
    $parent.find("g.pdln-#{decrease10(nextN)}").addClass('notransition')
      .css 'transform', 'rotateX(-72deg)'
    removeNoTransition()

  $('g.pdln-1').click moveUp

  moveDown = ->
    # Get index of number.
    codeIdx = parseInt @parentElement.id.match(/\d$/)[0]
    # Increase code number.
    n = code.increase codeIdx
    nextN = decrease10 n
    prevN = increase10 n
    # Remove current down event listener.
    $this = $(@).off 'click'
    $parent = $ @parentElement
    # Add another down event listener.
    $next = $parent.find("g.pdln-#{nextN}").click moveDown
    # Remove current up event listener.
    $current = $parent.find("g.pdln-#{n}").off 'click'
    # Add another up event listener.
    $prev = $parent.find("g.pdln-#{prevN}").click moveUp
    # Rotate visible numbers down.
    $prev.css 'transform', 'rotateX(36deg)'
    $current.css 'transform', 'rotateX(0)'
    $next.css('transform', 'rotateX(-36deg)')
    $this.css('transform', 'rotateX(-72deg)')
    # Move buttom number to up.
    $parent.find("g.pdln-#{decrease10(nextN, 3)}").addClass('notransition')
      .css 'transform', 'rotateX(72deg)'
    removeNoTransition()

  $('g.pdln-9').click moveDown
  