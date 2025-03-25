#include "ExploreModel.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>

ExploreModel::ExploreModel(QObject *parent)
    : QAbstractListModel(parent), networkManager(new QNetworkAccessManager(this)) {
    connect(networkManager, &QNetworkAccessManager::finished, this, &ExploreModel::onReplyFinished);
}

int ExploreModel::rowCount(const QModelIndex &) const {
    return items.count();
}

QVariant ExploreModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= items.size())
        return QVariant();

    const ExploreItem &item = items[index.row()];
    switch (role) {
    case IdRole: return item.id;
    case ImageUrlRole: return item.imageUrl;
    case LikesRole: return item.likes;
    default: return QVariant();
    }
}

QHash<int, QByteArray> ExploreModel::roleNames() const {
    return {
        {IdRole, "id"},
        {ImageUrlRole, "imageUrl"},
        {LikesRole, "likes"}
    };
}

void ExploreModel::fetchExploreImages() {
    QUrl url("http://yourserver.com/api/explore");
    QNetworkRequest request(url);
    networkManager->get(request);
}

void ExploreModel::onReplyFinished(QNetworkReply *reply) {
    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "Network error:" << reply->errorString();
        reply->deleteLater();
        return;
    }

    QByteArray responseData = reply->readAll();
    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);
    if (!jsonDoc.isArray()) {
        qWarning() << "Expected JSON array for explore items.";
        reply->deleteLater();
        return;
    }

    QJsonArray array = jsonDoc.array();

    beginResetModel();
    items.clear();
    for (const QJsonValue &val : array) {
        QJsonObject obj = val.toObject();
        ExploreItem item;
        item.id = obj["id"].toString();
        item.imageUrl = obj["imageUrl"].toString();
        item.likes = obj["likes"].toString();
        items.append(item);
    }
    endResetModel();

    emit countChanged();
    reply->deleteLater();
}
