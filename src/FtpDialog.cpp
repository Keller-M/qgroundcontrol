#include "FtpDialog.h"
#include <QDebug>
#include <QtNetwork>
#include <QQuickView>
#include <QQuickItem>


FtpDialog::FtpDialog(QObject *parent) :
QObject(parent), ftp(0){
    ftp = new QFtp;
}


FtpDialog::~FtpDialog()
{
    //Used to clear UI, but ours is removed by QGC. May need later
    //delete ui;
}


/**
 * @brief FtpDialog::getLogFile
 * Called for a signal connection from this file and test.qml.
 * Used for updating the UI's terminal output.
 * @param none
 * @return QString of the most updated log output.
 */
QString FtpDialog::getLogFile()
{
    return m_logFile;
}


/**
 * @brief FtpDialog::setLogFile
 * Called for a signal connection from this file and test.qml,
 * this is done by emitting the textChanged() signal.
 * Used for updating the UI's terminal output.
 * @param logFile - A QString that is the most updated version
 * of the log output.
 * @return A textChanged() signal emission
 */
void FtpDialog::setLogFile(const QString &logFile)
{
    m_logFile = logFile;
    emit textChanged();
}


/**
 * @brief FtpDialog::connectClicked
 * takes in a user inputted ip address for
 * the ftp they wish to connect to. It then connects the
 * signals needed to properly communicate with the server.
 * @param input - A QString containing a user's desired ip address.
 */
void FtpDialog::connectClicked(QString input)
{
    ftp->connectToHost(input);

    //Required login for the default IP address
    if(input == "ftp.dlptest.com")
    {
        ftp->login("dlpuser@dlptest.com","SzMf7rTE4pCrf9dV286GuNe4N");
    }

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


/**
 * @brief FtpDialog::downloadContent
 * Users can download any file from the ftp's main folder into
 * a desired location on their base computer.
 * The specific folder might change or be customizable.
 * @param none
 * @return none
 */
void FtpDialog::downloadContent()
{
    QWidget *prnt = nullptr;
    QString fileName;
    QUrl myUrl = QUrl::fromUserInput("ftp://dlpuser@dlptest.com:SzMf7rTE4pCrf9dV286GuNe4N@ftp.dlptest.com");
    myUrl.setScheme("ftp");
    QUrl myFile;

    /* Still trying to get the ftp to show in the dialog.
     * There is some issue with the WindowsNativeFileDialog, may need to find
     * a way to use QGC's custom dialog and still be able to get an ftp connection
     * with it.
     */
//    fileName = QFileDialog::getOpenFileName(this, tr("Save File"),
//                                       myUrl);
    myFile = QFileDialog::getOpenFileUrl(prnt, tr("Save File"), myUrl);

    //Makes sure that the file we are trying to get actually exists.
    localFile = new QFile(myFile.fileName());
    if (!localFile->open(QIODevice::WriteOnly))
    {
        delete localFile;
        return;
    }

    ftp->get(myFile.fileName(), localFile);

    //Add action to the log
    m_logFile.append(ftp->get(myFile.fileName(), localFile));
    m_logFile.append(ftp->currentCommand());
    setLogFile(m_logFile);

    //Debug output
    qDebug()<<ftp->get(myFile.fileName(), localFile);
    qDebug()<<ftp->currentCommand();



}


/**
 * @brief FtpDialog::uploadContent
 * Users can choose any file they want to upload to the ftp.
 * The uploaded file will
 */
void FtpDialog::uploadContent()
{
    //Makes sure the file we are trying to upload exists
    localFile = new QFile(QString("C:/Users/Keller/%1").arg(QString("uploadFile.txt")));
    if (!localFile->open(QIODevice::ReadWrite))
    {
        delete localFile;
        return;
    }


    //Add action to the log
    m_logFile.append(ftp->put(localFile, QString("uploadFile.txt")));
    m_logFile.append(ftp->currentCommand());
    setLogFile(m_logFile);

    //Debug output
    qDebug()<<ftp->put(localFile, QString("uploadFile.txt"));
    qDebug()<<ftp->currentCommand();



}

/**
 * @brief FtpDialog::closeFTP
 * closes the ftp connection between the user computer and
 * companion computer.
 */
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


/**
 * @brief FtpDialog::ftpCommandFinished
 * Determines whether the current command queued has finished or not.
 * Also has a "soft" error handling check that does not halt functions.
 * @param request The number representation of the ftp command currently
 *        queued.
 * @param error A bool representing whether the current command produced
 *        an error.
 */
void FtpDialog::ftpCommandFinished(int request, bool error)
{
    // Handle errors depending on the command causing it
    if(error)
    {

        m_logFile.append(QString("FTP request %1 returned: '%2'")
                       .arg(request)
                       .arg(ftp->errorString()));
        setLogFile(m_logFile);

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


/**
 * @brief FtpDialog::my_dataTransferProgress
 * Updates the user terminal with a transfer progress of a specific file.
 * @param downloaded Representation of the desired file's current bytes transfered.
 * @param total Representation of the desired file's size (in bytes) to be transfered.
 */
void FtpDialog::my_dataTransferProgress(qint64 downloaded, qint64 total)
{
    m_logFile.append(QString("Transfered %1 bytes out of %2.")
                   .arg(downloaded)
                   .arg(total));
    setLogFile(m_logFile);

    qDebug() << QString("Transfered %1 bytes out of %2.")
                .arg(downloaded)
                .arg(total);
}


/**
 * @brief FtpDialog::my_commandStarted
 * Updates the user terminal with what command has just started.
 * @param command The numerical representation of the command the ftp
 *        has just started.
 */
void FtpDialog::my_commandStarted(int command)
{
    m_logFile.append(QString("Launched command %1.")
                   .arg(command));
    setLogFile(m_logFile);

    qDebug() << QString("Launched command %1.")
                .arg(command);
}


/**
 * @brief FtpDialog::my_done
 * Updates the user terminal if there is any error with the ftp or it's connection
 * @param error A bool representing whether the current command produced
 *        an error.
 */
void FtpDialog::my_done(bool error)
{
    if(error)
    {
        m_logFile.append(QString("FTP_ERROR: '%1'").arg(ftp->errorString()));
        setLogFile(m_logFile);
        qDebug() << Q_FUNC_INFO << QString("FTP_ERROR: '%1'").arg(ftp->errorString());
    }
}

/**
 * @brief FtpDialog::my_stateChanged
 * Updates the user terminal on any state changes to the QFtp object.
 * This can help with debugging or understanding the ftp processes.
 * @param state The current command or state that the QFtp object is in.
 *        Defaults to an unknown status.
 */
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

    m_logFile.append(QString("FTP STATUS changed: '%1'").arg(text));
    setLogFile(m_logFile);
    qDebug() << Q_FUNC_INFO << QString("FTP STATUS changed: '%1'").arg(text);


}


/**
 * @brief FtpDialog::my_listInfo
 * A helper function for fetchFtpList() that is used to add the next files or folders the
 * local representation of the ftp's file system.
 * @param url Provides the next file or folder in the ftp file tree.
 */
void FtpDialog::my_listInfo(QUrlInfo url)
{
    ftpFileList->append(url.name());
}


/**-----CURRENTLY UNUSED-----
 * @brief FtpDialog::fetchFtpList
 * The function that creates a local representation of the ftp's current file tree.
 */
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
