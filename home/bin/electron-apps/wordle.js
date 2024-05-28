const electron = require('electron');
const { app, BrowserWindow } = electron;
app.setName("Wordle");

let mainWindow;

app.on('ready', () => {
    mainWindow = new BrowserWindow({
		autoHideMenuBar: true,
        width: 1000,
        height: 700
    });

    mainWindow.setTitle('Wordle');
    mainWindow.loadURL('https://www.nytimes.com/games/wordle/index.html');

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
});
