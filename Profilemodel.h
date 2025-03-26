#ifndef PROFILEMODEL_H
#define PROFILEMODEL_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonArray>

class ProfileModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName NOTIFY dataChanged)
    Q_PROPERTY(QString bio READ bio NOTIFY dataChanged)
    Q_PROPERTY(QString dpImage READ dpImage NOTIFY dataChanged)
    Q_PROPERTY(QString website READ website NOTIFY dataChanged)
    Q_PROPERTY(QString followers READ followers NOTIFY dataChanged)
    Q_PROPERTY(QString following READ following NOTIFY dataChanged)
    Q_PROPERTY(QJsonArray posts READ posts NOTIFY dataChanged)

public:
    explicit ProfileModel(QObject* parent = nullptr);

    Q_INVOKABLE void fetchUserProfile();

    Q_INVOKABLE void setAccessToken(const QString& token);

    QString userName() const;
    QString bio() const;
    QString dpImage() const;
    QString website() const;
    QString followers() const;
    QString following() const;
    QJsonArray posts() const;

signals:
    void dataChanged();

private slots:
    void onProfileReply(QNetworkReply* reply);

private:
    QNetworkAccessManager* networkManager;
    QString m_accessToken;

    QString m_userName;
    QString m_bio;
    QString m_dpImage;
    QString m_website;
    QString m_followers;
    QString m_following;
    QJsonArray m_posts;
};

#endif // PROFILEMODEL_H
