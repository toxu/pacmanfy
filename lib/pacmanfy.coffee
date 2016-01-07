{CompositeDisposable} = require 'atom'
PacmanfyView = require './pacmanfy-view'

module.exports = Pacmanfy =
  config:
    opacity:
      type: 'number'
      default: 1.0

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @pacmanView = new PacmanfyView()

    @subscriptions.add atom.commands.add 'atom-workspace', 'pacmanfy:toggle': => @toggle()

  deactivate: ->
    @subscriptions?.dispose()
    @subscriptions = null
    @pacmanView?.dispose()
    @pacmanView = null

  toggle: ->
    if @pacmanView.disabled
      @pacmanView.enable()
    else
      @pacmanView.disable()
