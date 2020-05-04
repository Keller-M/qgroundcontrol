// myudp.h

#ifndef MYUDP_H
#define MYUDP_H

#include <QObject>
#include <QUdpSocket>

class MyUDP : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString logFile READ getLogFile WRITE setLogFile NOTIFY textChanged)

public:
    explicit MyUDP(QObject *parent = 0);
    QString m_logFile = "";
    QString getLogFile();
    void setLogFile(const QString &logFile);
signals:
    void textChanged();
public slots:
    void readyRead();
    void readIncoming();
    void helloUDP();
private:
    QUdpSocket *socket;
};

#endif // MYUDP_H
