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

signals:
    void uploadFinished(bool success, QString message);

private slots:
    void onUploadFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *networkManager;
};

#endif // UPLOADMODEL_H
