class Dashing.CircleCi extends Dashing.Widget
  ready: ->
    @get('unordered')
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()

    if @items and @items.length > 0
      @_checkStatus(@items[0].state)

  onData: (data) ->
    if data.items and data.items.length > 0
      @_checkStatus(data.items[0].state)

  _checkStatus: (status) ->
    $(@node).removeClass('failed passed running started broken timedout no_tests fixed success canceled')
    $(@node).addClass(status)
