#include "FtpDialog.h"
#include <QDebug>


FtpDialog::FtpDialog(QObject *parent) :
QObject(parent){}


QFile *file;

FtpDialog::~FtpDialog()
{
//delete ui;
}

void FtpDialog::connectClicked()
{
//ui->connectButton->setEnabled(false);

 ftp.connectToHost("ftp.dlptest.com");
 ftp.login("dlpuser@dlptest.com","SzMf7rTE4pCrf9dV286GuNe4N");
// ui->statusLabel->setText(tr("Connecting to host..."));
}

void FtpDialog::downloadContent()
{
    file = new QFile(QString("C:/Users/Keller/%1").arg(QString("testFile.txt")));
    if (!file->open(QIODevice::WriteOnly)) {
          /*  QMessageBox::information(this, tr("FTP"),
                                     tr("Unable to save the file %1: %2.")
                                     .arg("testFile.txt").arg(file->errorString()));
            */delete file;
            return;
        }

    ftp.get(QString("testFile.txt"), file);

}

void FtpDialog::closeFTP()
{
    if(ftp.currentCommand() == QFtp::Get)
    {
    }
    else
    {
        file->close();
        ftp.close();
    }


}

/*void FtpDialog::ftpFinished(int request, bool error)
{
// Handle errors depending on the command caussing it
qDebug()<<ftp.currentCommand();
if(error)
{
switch(ftp.currentCommand())
{
case QFtp::ConnectToHost:
//QMessageBox::warning(this, tr("Error"), tr("Failed to connect to host."));
//ui->connectButton->setEnabled(true);

        break;
    case QFtp::Login:
  //      QMessageBox::warning(this, tr("Error"), tr("Failed to login."));
    //    ui->connectButton->setEnabled(true);

        break;

    case QFtp::List:
        //QMessageBox::warning(this, tr("Error"),
     //                        tr("Failed to get file list.\nClosing connection"));
        ftp.close();

        break;

    }

   // ui->statusLabel->setText(tr("Ready."));
}
// React to the current command and issue
// more commands or update the user interface
else
{
switch(ftp.currentCommand())
{
case QFtp::ConnectToHost:
ftp.login();

        break;
    case QFtp::Login:
        getFileList();

        break;

    case QFtp::Close:
        //ui->connectButton->setEnabled(true);
       // getFileList();

        break;
    case QFtp::List:
        //ui->disconnectButton->setEnabled(true);
        //ui->upButton->setEnabled(true);
        //ui->statusLabel->setText(tr("Ready."));

        break;
    case QFtp::Get:
        file->close();
        break;

    }
}
}
*/
void FtpDialog::getFileList()
{

}
