#include "Reelmodel.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

ReelModel::ReelModel(QObject *parent)
    : QAbstractListModel(parent), networkManager(new QNetworkAccessManager(this))
{
    connect(networkManager, &QNetworkAccessManager::finished, this, &ReelModel::onReplyFinished);
}

int ReelModel::rowCount(const QModelIndex &) const {
    return reels.count();
}

QVariant ReelModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= reels.size())
        return QVariant();

    const Reel &reel = reels[index.row()];
    switch (role) {
    case IdRole: return reel.id;
    case UserNameRole: return reel.userName;
    case AvatarRole: return reel.avatar;
    case DescriptionRole: return reel.description;
    case SongRole: return reel.song;
    case LikesRole: return reel.likes;
    case CommentsRole: return reel.comments;
    case ThumbnailRole: return reel.thumbnail;
    case VideoRole: return reel.videoUrl;
    default: return QVariant();
    }
}

QHash<int, QByteArray> ReelModel::roleNames() const {
    return {
        {IdRole, "id"},
        {UserNameRole, "userName"},
        {AvatarRole, "avatar"},
        {DescriptionRole, "description"},
        {SongRole, "song"},
        {LikesRole, "likes"},
        {CommentsRole, "comments"},
        {ThumbnailRole, "thumbnail"},
        {VideoRole, "videoUrl"}
    };
}

void ReelModel::fetchReels() {
    m_loading = true;
    emit loadingChanged();

    QUrl url("http://");
    QNetworkRequest request(url);
    networkManager->get(request);
}

void ReelModel::onReplyFinished(QNetworkReply *reply) {
    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Network error:" << reply->errorString();

        beginResetModel();
        reels.clear();

        // Fallback demo
        for (int i = 0; i < 2; ++i) {
            Reel reel;
            reel.id = QString::number(i + 1);
            reel.userName = "Demo User";
            reel.avatar = "qrc:/avatars/user1.jpg";
            reel.description = "This is a demo reel " + QString::number(i + 1);
            reel.song = "Demo Song";
            reel.likes = 1000 + i * 100;
            reel.comments = 50 + i * 10;
            reel.thumbnail = "";
            reel.videoUrl = "";
            reels.append(reel);
        }

        endResetModel();
        emit countChanged();
        reply->deleteLater();
        return;
    }

    QByteArray response = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(response);
    if (!doc.isArray()) {
        qWarning() << "Expected JSON array for reels";
        reply->deleteLater();
        return;
    }

    QJsonArray array = doc.array();
    beginResetModel();
    reels.clear();

    for (const QJsonValue &val : array) {
        QJsonObject obj = val.toObject();
        Reel reel;
        reel.id = obj["id"].toString();
        QJsonObject userObj = obj["user"].toObject();
        reel.userName = userObj["name"].toString();
        reel.avatar = userObj["avatar"].toString();
        reel.description = obj["description"].toString();
        reel.song = obj["song"].toString();
        reel.likes = obj["likes"].toInt();
        reel.comments = obj["comments"].toInt();
        reel.thumbnail = obj["thumbnail"].toString();
        reel.videoUrl = obj["videoUrl"].toString();
        reels.append(reel);
    }

    endResetModel();
    emit countChanged();
    m_loading = false;
    emit loadingChanged();
    reply->deleteLater();
}

bool ReelModel::isLoading() const {
    return m_loading;
}


