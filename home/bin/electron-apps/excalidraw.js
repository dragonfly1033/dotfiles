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
    mainWindow.loadURL('https://excalidraw.com/');

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
});
