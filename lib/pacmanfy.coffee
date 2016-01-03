{CompositeDisposable} = require 'atom'

module.exports = Pacmanfy =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    @editor = atom.workspace.getActiveTextEditor()
    @editorElement = atom.views.getView @editor
    @cursorElement = @editorElement.shadowRoot.querySelector(".cursor")
    @top = document.createElement "div"
    @bottom = document.createElement "div"
    @created = false

    @subscriptions.add atom.commands.add 'atom-workspace', 'pacmanfy:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->
    pacmanfyViewState: @pacmanfyView.serialize()

  enable: ->
    return until @cursorElement
    @top.classList.add "pac-top"
    @bottom.classList.add "pac-bottom"
    @cursorElement.classList.add "pacmanfy"
    @cursorElement.appendChild @top
    @cursorElement.appendChild @bottom

  disable: ->
    @top.classList.remove "pac-top"
    @top.classList.remove "pac-bottom"
    @cursorElement.classList.remove "pacmanfy"
    @cursorElement.removeChild @top
    @cursorElement.removeChild @bottom

  toggle: ->
    if not @created
      @enable()
      @created = true
    else
      @disable()
      @created = false
