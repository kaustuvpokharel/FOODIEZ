#ifndef PROFILEMODEL_H
#define PROFILEMODEL_H

#include <QObject>
#include <QtNetwork>
#include <QJsonArray>

class ProfileModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName NOTIFY dataChanged)
    Q_PROPERTY(QString bio READ bio NOTIFY dataChanged)
    Q_PROPERTY(QString dpImage READ dpImage NOTIFY dataChanged)
    Q_PROPERTY(QString website READ website NOTIFY dataChanged)
    Q_PROPERTY(QJsonArray posts READ posts NOTIFY dataChanged)
    Q_PROPERTY(QString followers READ followers NOTIFY dataChanged)
    Q_PROPERTY(QString following READ following NOTIFY dataChanged)

public:
    explicit ProfileModel(QObject* parent = nullptr);
    Q_INVOKABLE void fetchUserProfile(QString emailOrId);

    QString userName() const;
    QString bio() const;
    QString dpImage() const;
    QString website() const;
    QJsonArray posts() const;
    QString followers() const;
    QString following() const;

signals:
    void dataChanged();

private slots:
    void onProfileReply(QNetworkReply* reply);

private:
    QNetworkAccessManager* networkManager;
    QString m_userName, m_bio, m_dpImage, m_website;
    QString m_followers, m_following;
    QJsonArray m_posts;
};

#endif // PROFILEMODEL_H
