#ifndef LOGINAUTH_H
#define LOGINAUTH_H

#include <QObject>
#include <QtNetwork>

class LoginAuth: public QObject
{
    Q_OBJECT
public:
    LoginAuth(QObject* parent = nullptr);
    Q_INVOKABLE bool checkUser(QString email, QString password);

private:
    QTcpSocket* socket;

};

#endif // LOGINAUTH_H
