#ifndef FTPDIALOG_H
#define FTPDIALOG_H

#include <QDialog>
#include <QObject>
#include "qftp.h"
#include <QMessageBox>
#include <QDebug>
#include <QQuickView>
#include <QDir>
#include <QFileDialog>
#include <QNetworkConfigurationManager>

class QNetworkSession;

class FtpDialog : public QObject
{
    Q_OBJECT
    //The connection that allows us to update the terminal display of the QML file
    Q_PROPERTY(QString logFile READ getLogFile WRITE setLogFile NOTIFY textChanged)

    public:
        explicit FtpDialog(QObject *parent = nullptr);
        QFile *localFile;
        QStringList *ftpFileList;
        QDir *photoDir;
        QQuickView* myView;
        QObject *object;
        QString m_logFile = "";
        QString getLogFile();
        QNetworkSession *networkSession;
        QNetworkConfigurationManager manager;
        void setLogFile(const QString &logFile);
        ~FtpDialog();

    public slots:
        void connectClicked(QString, QString, QString);
        void ftpCommandFinished(int, bool);
        void downloadContent();
        void uploadContent();
        void fetchFtpList();
        void closeFTP();

        //Overridden connector functions (adds the debug output to the UI terminal)
        void my_dataTransferProgress(qint64, qint64);
        void my_commandStarted(int);
        void my_done(bool);
        void my_stateChanged(int);
        void my_listInfo(QUrlInfo);

    signals:
        void textChanged();
    public:
        QFtp * ftp;
        QString m_address;
        QString m_user;
        QString m_pass;
};

#endif // FTPDIALOG_H
