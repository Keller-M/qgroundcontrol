#include <QApplication>
#include "ftpwindow.h"

#ifdef Q_OS_SYMBIAN
#include <QDir>
#include <QDesktopWidget>
#endif

int testInterface()
{/*
    Q_INIT_RESOURCE(ftp);
#ifdef Q_OS_SYMBIAN
    // Change current directory from default private to c:\data
    // in order that user can access the downloaded content
    QDir::setCurrent( "c:\\data" );
#endif
    QApplication app();
    FtpWindow ftpWin;
#ifdef Q_OS_SYMBIAN
    // Make application better looking and more usable on small screen
    ftpWin.showMaximized();
#else
    ftpWin.show();
#endif
    return ftpWin.exec();*/
    return 0;
}
