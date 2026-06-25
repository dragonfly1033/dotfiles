const electron = require('electron');
const { app, BrowserWindow } = electron;
app.setName('gpt');

let mainWindow;

app.on('ready', () => {
    mainWindow = new BrowserWindow({
		autoHideMenuBar: true,
        width: 1000,
        height: 700
    });


    mainWindow.setTitle('gpt');
    mainWindow.loadURL('https://chatgpt.com/');

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
});
