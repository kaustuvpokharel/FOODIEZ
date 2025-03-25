#ifndef REELMODEL_H
#define REELMODEL_H

#include <QAbstractListModel>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class ReelModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(bool loading READ isLoading NOTIFY loadingChanged)
public:
    enum ReelRoles {
        IdRole = Qt::UserRole + 1,
        UserNameRole,
        AvatarRole,
        DescriptionRole,
        SongRole,
        LikesRole,
        CommentsRole,
        ThumbnailRole,
        VideoRole
    };

    explicit ReelModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void fetchReels();
    bool isLoading() const;

signals:
    void countChanged();
    void loadingChanged();

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    struct Reel {
        QString id;
        QString userName;
        QString avatar;
        QString description;
        QString song;
        int likes;
        int comments;
        QString thumbnail;
        QString videoUrl;
    };

    bool m_loading = true;
    QList<Reel> reels;
    QNetworkAccessManager* networkManager;
};

#endif // REELMODEL_H
