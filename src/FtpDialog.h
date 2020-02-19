#ifndef FTPDIALOG_H
#define FTPDIALOG_H

#include <QDialog>
#include <QObject>
#include "qftp.h"
#include <QMessageBox>
#include <QDebug>

class FtpDialog : public QObject
{
Q_OBJECT

public:
QFile *localFile;
QStringList *ftpFileList;
QDir *photoDir;
QString *curState;
explicit FtpDialog(QObject *parent = 0);
~FtpDialog();

public slots:
void connectClicked();
void ftpCommandFinished(int, bool);
void downloadContent();
void uploadContent();
void fetchFtpList();
void closeFTP();

void my_dataTransferProgress(qint64, qint64);
void my_commandStarted(int);
void my_done(bool);
void my_stateChanged(int);
void my_listInfo(QUrlInfo);

//QString getState();

signals:
public:
QFtp * ftp;
};

#endif // FTPDIALOG_H
