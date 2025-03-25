#include "Profilemodel.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

ProfileModel::ProfileModel(QObject* parent) : QObject(parent) {
    networkManager = new QNetworkAccessManager(this);
    connect(networkManager, &QNetworkAccessManager::finished, this, &ProfileModel::onProfileReply);
}

void ProfileModel::fetchUserProfile(QString emailOrId) {
    QUrl url("http://.com/api/userprofile?email=" + emailOrId); //reoplace later
    QNetworkRequest req(url);
    networkManager->get(req);
}

void ProfileModel::onProfileReply(QNetworkReply* reply) {
    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << "Error fetching profile:" << reply->errorString();
        return;
    }

    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonObject obj = doc.object();

    m_userName = obj["username"].toString();
    m_bio = obj["bio"].toString();
    m_dpImage = obj["dp"].toString();
    m_website = obj["website"].toString();
    m_followers = obj["followers"].toString();
    m_following = obj["following"].toString();
    m_posts = obj["posts"].toArray();

    emit dataChanged();
    reply->deleteLater();
}

QString ProfileModel::userName() const { return m_userName; }
QString ProfileModel::bio() const { return m_bio; }
QString ProfileModel::dpImage() const { return m_dpImage; }
QString ProfileModel::website() const { return m_website; }
QJsonArray ProfileModel::posts() const { return m_posts; }
QString ProfileModel::followers() const { return m_followers; }
QString ProfileModel::following() const { return m_following; }
