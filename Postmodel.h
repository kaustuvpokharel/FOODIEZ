#ifndef POSTMODEL_H
#define POSTMODEL_H

#include <QAbstractListModel>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class PostModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(bool loading READ isLoading NOTIFY loadingChanged)
public:
    enum PostRoles {
        IdRole = Qt::UserRole + 1,
        UserNameRole,
        AvatarRole,
        ImageRole,
        LikesRole,
        CommentsRole,
        CaptionRole,
        TimestampRole
    };

    bool isLoading() const;

    explicit PostModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void fetchPosts();

private slots:
    void onReplyFinished(QNetworkReply *reply);

signals:
    void countChanged();
    void loadingChanged();

private:
    struct Post {
        QString id;
        QString userName;
        QString avatar;
        QString image;
        int likes;
        int comments;
        QString caption;
        QString timestamp;
    };

    bool m_loading = true;
    QList<Post> posts;
    QNetworkAccessManager* networkManager;
};

#endif // POSTMODEL_H
