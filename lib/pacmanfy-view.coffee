{CompositeDisposable} = require 'atom'

module.exports =
class PacmanfyView

  constructor: ->
    @init()
    @disable()
    @listenConfigChange()
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
      @moveSubscription?.dispose()
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
    @cursorElement?.style.opacity = atom.config.get('pacmanfy.opacity')
    top = document.createElement "div"
    bottom = document.createElement "div"
    if not @cursorElement?.hasChildNodes()
      top.classList.add "pac-top"
      bottom.classList.add "pac-bottom"
      @cursorElement?.classList.add "pacmanfy"
      @cursorElement?.appendChild top
      @cursorElement?.appendChild bottom
    @moveSubscription = @editor?.onDidChangeCursorPosition (event) =>
      @move(event)

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

  move: (event) =>
    # console.log event.oldScreenPosition
    # console.log event.newScreenPosition
    @cursorElement = @editorElement?.shadowRoot.querySelector(".cursor")
    if @cursorElement?.hasChildNodes()
      top = @editorElement.shadowRoot.querySelector(".pac-top")
      bottom = @editorElement.shadowRoot.querySelector(".pac-bottom")
    return until top and bottom
    if event.newScreenPosition.row > event.oldScreenPosition.row
      @turndown(top, bottom)
      return
    if event.newScreenPosition.row < event.oldScreenPosition.row
      @turnup(top, bottom)
      return
    if event.newScreenPosition.column > event.oldScreenPosition.column
      @turnright(top, bottom)
    if event.newScreenPosition.column < event.oldScreenPosition.column
      @turnleft(top, bottom)

  turnleft: (top, bottom) =>
      top.style.webkitAnimationName = 'spin-top-left'
      bottom.style.webkitAnimationName = 'spin-bottom-left'

  turnright: (top, bottom) =>
      top.style.webkitAnimationName = 'spin-top-right'
      bottom.style.webkitAnimationName = 'spin-bottom-right'

  turnup: (top, bottom) =>
      top.style.webkitAnimationName = 'spin-top-up'
      bottom.style.webkitAnimationName = 'spin-bottom-up'

  turndown: (top, bottom) =>
      top.style.webkitAnimationName = 'spin-top-down'
      bottom.style.webkitAnimationName = 'spin-bottom-down'

  listenConfigChange: ->
    atom.config.onDidChange 'pacmanfy.opacity', =>
      if not @disabled
        @debounceCreatePacmanfy()
