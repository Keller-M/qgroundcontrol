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
explicit FtpDialog(QObject *parent = 0);
~FtpDialog();

public slots:
void connectClicked();
//void ftpFinished(int, bool);
void downloadContent();
void getFileList();
void closeFTP();
signals:

private:
QFtp ftp;
};

#endif // FTPDIALOG_H
