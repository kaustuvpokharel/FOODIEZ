#ifndef UPLOADMODEL_H
#define UPLOADMODEL_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QHttpMultiPart>
#include <QNetworkReply>

class UploadModel : public QObject
{
    Q_OBJECT
public:
    explicit UploadModel(QObject *parent = nullptr);

    Q_INVOKABLE void uploadPost(const QString &imagePath, const QString &caption);
    Q_INVOKABLE void setAccessToken(const QString &token);

signals:
    void uploadFinished(bool success, QString message);
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);

private slots:
    void onUploadFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *networkManager;

    QString accessToken;
};

#endif // UPLOADMODEL_H
