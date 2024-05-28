const electron = require('electron');
const { app, BrowserWindow } = electron;
app.setName('mail');

let mainWindow;

app.on('ready', () => {
    mainWindow = new BrowserWindow({
		autoHideMenuBar: true,
        width: 1000,
        height: 700
    });

    mainWindow.setTitle('mail');
    mainWindow.loadURL('https://mail.google.com');

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
});
