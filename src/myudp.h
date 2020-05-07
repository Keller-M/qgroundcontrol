// myudp.h

#ifndef MYUDP_H
#define MYUDP_H

#include <QObject>
#include <QUdpSocket>

extern QString g_addr;
extern QHostAddress g_adddr;
extern int g_status;
extern int g_port;

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
    void HelloUDP();
    void startUDP();
    void stopUDP();
private:
    QUdpSocket *socket;
};

#endif // MYUDP_H
