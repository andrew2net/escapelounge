$(document).ready(()->
    $('.collapse').on('show.bs.collapse', (e)->
        $('.collapse').collapse("hide")
    )
)
