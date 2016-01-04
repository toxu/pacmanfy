{CompositeDisposable} = require 'atom'

module.exports =
class PacmanfyView

  constructor: ->
    @init()
    @enable()
    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem =>
      @init()
      if @disabled
        @debounceDestroyPacmanfy()
      else
        @debounceCreatePacmanfy()

  init: =>
    @subscribeToActiveTextEditor()
    @editorElement = atom.views.getView @editor
    @pacmanSubscription = @editor?.onDidChangeSelectionRange =>
      if not @disabled
        @debounceCreatePacmanfy()

  enable: =>
    @disabled = false
    @createPacman()

  disable: =>
    @disabled = true
    @destroyPacman()

  createPacman: =>
    @cursorElement = @editorElement?.shadowRoot.querySelector(".cursor")
    top = document.createElement "div"
    bottom = document.createElement "div"
    if not @cursorElement?.hasChildNodes()
      top.classList.add "pac-top"
      bottom.classList.add "pac-bottom"
      @cursorElement?.classList.add "pacmanfy"
      @cursorElement?.appendChild top
      @cursorElement?.appendChild bottom

  destroyPacman: =>
    @cursorElement = @editorElement?.shadowRoot.querySelector(".cursor")
    if @cursorElement?.hasChildNodes()
      top = @editorElement.shadowRoot.querySelector(".pac-top")
      bottom = @editorElement.shadowRoot.querySelector(".pac-bottom")
      top.classList.remove "pac-top"
      bottom.classList.remove "pac-bottom"
      @cursorElement?.classList.remove "pacmanfy"
      @cursorElement?.removeChild top
      @cursorElement?.removeChild bottom

  debounceCreatePacmanfy: =>
    clearTimeout(@handleCreateTimeout)
    @handleCreateTimeout = setTimeout =>
      @createPacman()
    , 10

  debounceDestroyPacmanfy: =>
    clearTimeout(@handleDestroyTimeout)
    @handleDestroyTimeout = setTimeout =>
      @destroyPacman()
    , 10

  subscribeToActiveTextEditor: =>
    @editor = @getActiveTextEditor()

  getActiveTextEditor: ->
    atom.workspace.getActiveTextEditor()
