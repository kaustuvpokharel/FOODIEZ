#ifndef LOGINAUTH_H
#define LOGINAUTH_H

#include <QObject>
#include <QtNetwork>

class LoginAuth: public QObject
{
    Q_OBJECT
public:
    LoginAuth(QObject* parent = nullptr);
    Q_INVOKABLE void checkUser(QString email, QString password);

signals:
    void authResult(bool result);

private slots:
    void onReplyFinished(QNetworkReply* reply);
private:
    QNetworkAccessManager* networkManager;
    QString accessToken;
    QString refreshToken;

};

#endif // LOGINAUTH_H
