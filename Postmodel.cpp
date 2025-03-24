#include "PostModel.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

PostModel::PostModel(QObject *parent)
    : QAbstractListModel(parent), networkManager(new QNetworkAccessManager(this))
{
    connect(networkManager, &QNetworkAccessManager::finished, this, &PostModel::onReplyFinished);
}

int PostModel::rowCount(const QModelIndex &) const {
    return posts.count();
}

QVariant PostModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= posts.size())
        return QVariant();

    const Post &post = posts[index.row()];

    switch (role) {
    case IdRole: return post.id;
    case UserNameRole: return post.userName;
    case AvatarRole: return post.avatar;
    case ImageRole: return post.image;
    case LikesRole: return post.likes;
    case CommentsRole: return post.comments;
    case CaptionRole: return post.caption;
    case TimestampRole: return post.timestamp;
    default: return QVariant();
    }
}

QHash<int, QByteArray> PostModel::roleNames() const {
    return {
        {IdRole, "id"},
        {UserNameRole, "userName"},
        {AvatarRole, "avatar"},
        {ImageRole, "image"},
        {LikesRole, "likes"},
        {CommentsRole, "comments"},
        {CaptionRole, "caption"},
        {TimestampRole, "timestamp"}
    };
}

void PostModel::fetchPosts() {
    m_loading = true;
    emit loadingChanged();

    QUrl url("http://yourserverhrtr");
    QNetworkRequest request(url);
    networkManager->get(request);
}

void PostModel::onReplyFinished(QNetworkReply *reply) {
    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Network error:" << reply->errorString();

        // Use fallback demo data
        beginResetModel();
        posts.clear();

        for (int i = 0; i < 3; ++i) {
            Post post;
            post.id = QString::number(i + 1);
            post.userName = "Demo User " + QString::number(i + 1);
            post.avatar = "qrc:/avatar/Assets/images/default_avatar.png";
            post.image = "qrc:/placeholders/Assets/images/placeholder.png";
            post.likes = 10 * (i + 1);
            post.comments = 3 * (i + 1);
            post.caption = "This is a demo post caption.";
            post.timestamp = "Just now";
            posts.append(post);
        }

        endResetModel();
        emit countChanged();
        reply->deleteLater();
        return;
    }

    QByteArray response = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(response);
    if (!doc.isArray()) {
        qWarning() << "Expected a JSON array";
        reply->deleteLater();
        return;
    }

    QJsonArray jsonArray = doc.array();

    beginResetModel();
    posts.clear();

    for (const QJsonValue &val : jsonArray) {
        QJsonObject obj = val.toObject();
        Post post;
        post.id = obj["id"].toString();
        QJsonObject userObj = obj["user"].toObject();
        post.userName = userObj["name"].toString();
        post.avatar = userObj["avatar"].toString();
        post.image = obj["image"].toString();
        post.likes = obj["likes"].toInt();
        post.comments = obj["comments"].toInt();
        post.caption = obj["caption"].toString();
        post.timestamp = obj["timestamp"].toString();
        posts.append(post);
    }

    endResetModel();
    emit countChanged();
    reply->deleteLater();
    m_loading = false;
    emit loadingChanged();
}

bool PostModel::isLoading() const {
    return m_loading;
}
