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
    QUrl url("https://foodiez.vaskrneup.com/user/api/token/");
    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json; charset=utf-8");
    qInfo() << email << "\n" << password;
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
    QJsonParseError parseError;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData, &parseError);
    if (parseError.error != QJsonParseError::NoError) {
        qDebug() << "JSON parse error:" << parseError.errorString();
        emit authResult(false);
        reply->deleteLater();
        return;
    }

    QJsonObject jsonObj = jsonDoc.object();

    if (jsonObj.contains("access") && jsonObj.contains("refresh") && jsonObj.contains("user")) {
        qDebug() << "Login successful!";
        qDebug() << "Access Token:" << jsonObj["access"].toString();
        qDebug() << "Refresh Token:" << jsonObj["refresh"].toString();

        accessToken = jsonObj["access"].toString();
        refreshToken = jsonObj["refresh"].toString();

        emit authResult(true);
    } else {
        qDebug() << "Login failed: Missing tokens or user data in response";
        emit authResult(false);
    }

    reply->deleteLater();
}

