#include "myudp.h"
#include <QHostAddress>
// myudp.cpp

QString g_addr = "10.42.0.1";
QHostAddress g_adddr = QHostAddress(QString("10.42.0.1"));
int g_status = 0;

MyUDP::MyUDP(QObject *parent) : QObject(parent)
{
    socket = new QUdpSocket(this);
    socket->connectToHost(g_adddr, 9090);
//    socket->bind(g_adddr, 9090);
    connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));
    inSocket = new QUdpSocket;
    inSocket->bind(9091,QUdpSocket::ShareAddress);
    connect(inSocket, SIGNAL(readyRead()),this, SLOT(readyRead()));
}

void MyUDP::helloUDP()
{
    QByteArray Data;

    Data.append("//IP");

//    socket->writeDatagram(Data, QHostAddress::LocalHost, 9090);
    socket->writeDatagram(Data, g_adddr, 9090);
    emit textChanged();
}

void MyUDP::startUDP()
{
    qDebug() << "Trying to connect.\n";
    setLogFile("Trying to connect.\n");
    QByteArray Data;
    if (g_status == 0) {
        Data.append("//CMD:start");
//        socket->writeDatagram(Data, QHostAddress::LocalHost, 9090);
        socket->writeDatagram(Data, g_adddr, 9090);
        g_status = 1;
    } else {
        Data.append("//INFO: Radio already started.");
//        socket->writeDatagram(Data, QHostAddress::LocalHost, 9090);
        socket->writeDatagram(Data, g_adddr, 9090);
    }
    emit textChanged();
}

void MyUDP::stopUDP()
{
    QByteArray Data;
    if (g_status == 1) {
        Data.append("//CMD:stop");

//        socket->writeDatagram(Data, QHostAddress::LocalHost, 9090);
        socket->writeDatagram(Data, g_adddr, 9090);
        g_status = 0;
    } else {
        Data.append("//INFO: Radio already stopped.");
//        socket->writeDatagram(Data, QHostAddress::LocalHost, 9090);
        socket->writeDatagram(Data, g_adddr, 9090);
    }

    emit textChanged();
}

void MyUDP::readIncoming() {
    // when data comes in
    QByteArray buffer;
    buffer.resize(socket->pendingDatagramSize());

    QHostAddress sender;
    quint16 senderPort;

    socket->readDatagram(buffer.data(), buffer.size(), &sender, &senderPort);

    qDebug() << "Message from: " << sender.toString();
    qDebug() << "Message port: " << senderPort;
    qDebug() << "Message: " << buffer;
}

QString MyUDP::getLogFile()
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
void MyUDP::setLogFile(const QString &logFile)
{
    m_logFile = logFile +"\n";
    qDebug() << "Logfile changed";
    emit textChanged();
}

void MyUDP::readyRead()
{
    qDebug() << "Incoming data.\n";
    // when data comes in
    QByteArray buffer;
    buffer.resize(socket->pendingDatagramSize());

    QHostAddress sender;
    quint16 senderPort;

    socket->readDatagram(buffer.data(), buffer.size(), &sender, &senderPort);

    qDebug() << "Message from: " << sender.toString();
    qDebug() << "Message port: " << senderPort;
    qDebug() << "Message: " << buffer;

    if (buffer == "//CMD:start") {
        m_logFile.append(QString("//INFO:start\n"));
    } else if (buffer == "//CMD:stop") {
        m_logFile.append(QString("//INFO:stop\n"));
    }else if (buffer == "//IP:") {
        m_logFile.append(QString(buffer+"\n"));
    } else if (buffer == "//CMD:echo") {
        m_logFile.append(QString("//echo:"+buffer+"\n"));
    } else {
        m_logFile.append(QString(buffer+"\n"));
    }
    //m_logFile.append(QString("Message from: " + sender.toString() + "\n"));
    emit textChanged();
}
