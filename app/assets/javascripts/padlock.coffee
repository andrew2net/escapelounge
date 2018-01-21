$ ->
  getTransformRotateX = ($element) ->

    matrix = $element.css('transform')
    rotateX = 0
    # rotateY = 0
    # rotateZ = 0

    if /matrix3d/.test matrix
      # do some magic
      values = matrix.split('(')[1].split(')')[0].split(',')
      pi = Math.PI
      sinB = parseFloat(values[8])
      b = Math.round(Math.asin(sinB) * 180 / pi)
      cosB = Math.cos(b * pi / 180)
      matrixVal10 = parseFloat(values[9])
      a = Math.round(Math.asin(-matrixVal10 / cosB) * 180 / pi)
      # matrixVal1 = parseFloat(values[0])
      # c = Math.round(Math.acos(matrixVal1 / cosB) * 180 / pi)

      rotateX = a
      # rotateY = b
      # rotateZ = c
    rotateX

  inputs = [$('#n0'), $('#n1'), $('#n2')]

  increase10 = (x, n = 1) -> if x + n <= 9 then x + n else x + n - 10
  decrease10 = (x, n = 1) -> if x - n >= 0 then x - n else 10 - n + x

  code = {
    values: [0, 0, 0]
    increase: (idx) -> @values[idx] = increase10 @values[idx]
    decrease: (idx) -> @values[idx] = decrease10 @values[idx]
  }

  moveUp = ->
    # Get index of number.
    codeIdx = parseInt @parentElement.id.match(/\d$/)[0]
    # Cacl new current value.
    n = code.decrease codeIdx
    # Set input value.
    inputs[codeIdx].val n
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

  $('g.pdln-1').click moveUp

  moveDown = ->
    # Get index of number.
    codeIdx = parseInt @parentElement.id.match(/\d$/)[0]
    # Increase code number.
    n = code.increase codeIdx
    inputs[codeIdx].val n
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

  $('g.pdln-9').click moveDown
  
  $('g#pdl-0, g#pdl-1, g#pdl-2').on 'transitionstart', ->
    $('.notransition').removeClass 'notransition'
    # $(@).find('g').show()
