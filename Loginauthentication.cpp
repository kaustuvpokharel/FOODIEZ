#include "Loginauthentication.h"

LoginAuth::LoginAuth(QObject* parent)
{
    networkManager = new QNetworkAccessManager(this);
    connect(networkManager, &QNetworkAccessManager::finished, this, &LoginAuth::onReplyFinished);
}

/* Takes user credentials to send and check from the server
 *
 * @parem input email and password from user (passed inside qml)
 * @returns 'true' or 'false' after authentication
 */
void LoginAuth::checkUser(QString email, QString password)
{
    QUrl url("http://severLink");
    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject json;
    json["email"] = email;
    json["password"] = password;

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();
    networkManager->post(request, data);
}

void LoginAuth::onReplyFinished(QNetworkReply *reply)
{
    if(reply->error() != QNetworkReply::NoError)
    {
        qDebug() << "Network error:" << reply->errorString();
        emit authResult(false);

        reply->deleteLater();
        return;
    }

    QByteArray responseData = reply ->readAll();
    QString response = QString::fromUtf8(responseData).trimmed();

    if(response == "1" || response == "true" || response.contains("success"))
    {
        emit authResult(true);
    }
    else
    {
        emit authResult(false);
    }

    reply->deleteLater();
}

