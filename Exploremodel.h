#ifndef EXPLOREMODEL_H
#define EXPLOREMODEL_H

#include <QAbstractListModel>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class ExploreModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        ImageUrlRole,
        LikesRole
    };

    explicit ExploreModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void fetchExploreImages();

signals:
    void countChanged();

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    struct ExploreItem {
        QString id;
        QString imageUrl;
        QString likes;
    };

    QList<ExploreItem> items;
    QNetworkAccessManager *networkManager;
};

#endif // EXPLOREMODEL_H
