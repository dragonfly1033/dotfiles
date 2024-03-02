const electron = require('electron');
const { app, BrowserWindow } = electron;

let mainWindow;

app.on('ready', () => {
    mainWindow = new BrowserWindow({
		autoHideMenuBar: true,
        width: 1000,
        height: 700
    });

    mainWindow.setTitle('Excalidraw');
    mainWindow.loadURL('https://www.nytimes.com/games/wordle/index.html');

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
});
