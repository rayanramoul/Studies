const { app, BrowserWindow } = require('electron')
  let win
  function createWindow () {
    // Créer le browser window.
    win = new BrowserWindow({ width: 1360, height: 768 ,title:"Compilator"})
  
    // et charge le index.html de l'application.
    win.loadFile('UI/index.html')
  
    // Ouvre les DevTools.
    win.webContents.openDevTools()
    win.title="Compilator"
    win.on('closed', () => {
      win = null
    })
  }

  app.on('ready', createWindow)
  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
      app.quit()
    }
  })
  
  app.on('activate', () => {

    if (win === null) {
      createWindow()
    }
  })