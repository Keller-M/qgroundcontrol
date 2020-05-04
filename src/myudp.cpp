#include "myudp.h"

// myudp.cpp

#include "myudp.h"

MyUDP::MyUDP(QObject *parent) : QObject(parent)
{
    socket = new QUdpSocket(this);

    socket->bind(QHostAddress::LocalHost, 1234);

    connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));
}

void MyUDP::helloUDP()
{
    QByteArray Data;

    Data.append("Hello from UDP");

    socket->writeDatagram(Data, QHostAddress::LocalHost, 1234);
    m_logFile.append(QString("TESTING\n"));
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
    emit textChanged();
}

void MyUDP::readyRead()
{
    // when data comes in
    QByteArray buffer;
    buffer.resize(socket->pendingDatagramSize());

    QHostAddress sender;
    quint16 senderPort;

    socket->readDatagram(buffer.data(), buffer.size(), &sender, &senderPort);

    qDebug() << "Message from: " << sender.toString();
    qDebug() << "Message port: " << senderPort;
    qDebug() << "Message: " << buffer;


    m_logFile.append(QString("Message from: " + sender.toString() + "\n"));
    m_logFile.append(QString("Message: " + buffer + "\n"));
    emit textChanged();
}
