#include "FtpDialog.h"
#include <QDebug>
#include <QtNetwork>




FtpDialog::FtpDialog(QObject *parent) :
QObject(parent), ftp(0){
    ftp = new QFtp;
}


FtpDialog::~FtpDialog()
{
//delete ui;
}

void FtpDialog::connectClicked()
{

 ftp->connectToHost("ftp.dlptest.com");
 ftp->login("dlpuser@dlptest.com","SzMf7rTE4pCrf9dV286GuNe4N");

 connect(ftp, SIGNAL(dataTransferProgress(qint64, qint64)),
         this, SLOT(my_dataTransferProgress(qint64,qint64)));

 connect(ftp, SIGNAL(commandStarted(int)),
         this, SLOT(my_commandStarted(int)));

 connect(ftp, SIGNAL(commandFinished(int, bool)),
         this, SLOT(ftpCommandFinished(int, bool)));

 connect(ftp, SIGNAL(done(bool)),
         this, SLOT(my_done(bool)));

 connect(ftp, SIGNAL(stateChanged(int)),
         this, SLOT(my_stateChanged(int)));

 connect(ftp, SIGNAL(listInfo(QUrlInfo)),
         this, SLOT(my_listInfo(QUrlInfo)));

}

void FtpDialog::downloadContent()
{
    //connect(ftp, SIGNAL(commandFinished(int,bool)), &loop, SLOT(quit()));
    QWidget *parent = 0;
    QString fileName;
    fileName = QFileDialog::getSaveFileName(parent, tr("Save File"),
                                        "ftp://dlpuser@dlptest.com:SzMf7rTE4pCrf9dV286GuNe4N@ftp.dlptest.com/uploadFile.txt"
                                        );

    //localFile = new QFile(QString("C:/Users/Keller/%1").arg(QString("testFile.txt")));
    localFile = new QFile(QString("ftp://dlpuser@dlptest.com:SzMf7rTE4pCrf9dV286GuNe4N@ftp.dlptest.com/uploadFile.txt"));
    if (!localFile->open(QIODevice::WriteOnly)) {
          /*  QMessageBox::information(this, tr("FTP"),
                                     tr("Unable to save the file %1: %2.")
                                     .arg("testFile.txt").arg(file->errorString()));
            */

            return;
        }



    ftp->get(fileName, localFile);
    qDebug()<<"test output";
    qDebug()<<ftp->get(fileName, localFile);
    qDebug()<<ftp->currentCommand();



}

void FtpDialog::uploadContent()
{
    localFile = new QFile(QString("C:/Users/Keller/%1").arg(QString("uploadFile.txt")));
    if (!localFile->open(QIODevice::ReadWrite)) {
          /*  QMessageBox::information(this, tr("FTP"),
                                     tr("Unable to save the file %1: %2.")
                                     .arg("testFile.txt").arg(file->errorString()));
            */
            return;
        }



    qDebug()<<ftp->put(localFile, QString("uploadFile.txt"));
    qDebug()<<ftp->currentCommand();



}

void FtpDialog::closeFTP()
{
    if(ftp->currentCommand() == QFtp::Get)
    {
    }
    else
    {
        ftp->close();
    }


}

void FtpDialog::ftpCommandFinished(int request, bool error)
{
    // Handle errors depending on the command causing it
    if(error)
    {
        qDebug() << QString("FTP request %1 returned: '%2'")
                    .arg(request)
                    .arg(ftp->errorString());
    }
    else
    {
        if(ftp->currentCommand() == QFtp::List)
        {
            fetchFtpList();
        }
        if(ftp->currentCommand() == QFtp::Get)
        {
            localFile->close();
        }
    }
}
/*
void FtpDialog::fetchFtpList()
{
    qDebug() << Q_FUNC_INFO << "Entering...";
        if(!ftpFileList->isEmpty())
        {
            QString item = ftpFileList->takeFirst();
            QString img_local_path = QString(photoDir->path().append("/%1").arg(item));
            localFile = new QFile(img_local_path);

            if(!localFile->open(QIODevice::WriteOnly))
            {
                delete localFile;
                return;
            }

            QString ftp_file = QString("/%1").arg(item);
            ftp->get(ftp_file, localFile);
        }

}
*/

void FtpDialog::my_dataTransferProgress(qint64 downloaded, qint64 total)
{
    qDebug() << QString("Downloaded %1 bytes out of %2.")
                .arg(downloaded)
                .arg(total);
}

void FtpDialog::my_commandStarted(int command)
{
    qDebug() << QString("Launched command %1.")
                .arg(command);
}


void FtpDialog::my_done(bool error)
{
    if(error)
    {
        qDebug() << Q_FUNC_INFO << QString("FTP_ERROR: '%1'").arg(ftp->errorString());
    }
}

void FtpDialog::my_stateChanged(int state)
{
    QString text;
    switch (state)
    {
        case 0:
            text = "QFtp::Unconnected";
            break;
        case 1:
            text = "QFtp::HostLookup";
            break;
        case 2:
            text = "QFtp::Connecting";
            break;
        case 3:
            text = "QFtp::Connected";
            break;
        case 4:
            text = "QFtp::LoggingIn";
            break;
        case 5:
            text = "QFtp::Closing";
            break;
        default:
            text = "UNKNOWN STATUS!";
            break;
    }
    qDebug() << Q_FUNC_INFO << QString("FTP STATUS changed: '%1'").arg(text);


}

void FtpDialog::my_listInfo(QUrlInfo url)
{
    ftpFileList->append(url.name());
}

void FtpDialog::fetchFtpList()
{
    qDebug() << Q_FUNC_INFO << "Entering...";
       if(!ftpFileList->isEmpty())
       {
           QString item = ftpFileList->takeFirst();
           QString img_local_path = QString(photoDir->path().append("/%1").arg(item));
           localFile = new QFile(img_local_path);

           if(!localFile->open(QIODevice::WriteOnly))
           {
               delete localFile;
               return;
           }

           QString ftp_file = QString("/%1").arg(item);
           ftp->get(ftp_file, localFile);
       }
}

/*
QString getState()
{
    return QString("current state");//*curState;
}*/


