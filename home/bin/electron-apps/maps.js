const electron = require('electron');
const { app, BrowserWindow } = electron;
app.setName('maps');

let mainWindow;

app.on('ready', () => {
    mainWindow = new BrowserWindow({
		autoHideMenuBar: true,
        width: 1000,
        height: 700
    });

    mainWindow.setTitle('maps');
    mainWindow.loadURL('https://maps.google.com/maps');

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
});
