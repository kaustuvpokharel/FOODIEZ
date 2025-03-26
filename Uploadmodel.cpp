#include "Uploadmodel.h"
#include <QFileInfo>
#include <QHttpPart>
#include <QFile>
#include <QUrl>

UploadModel::UploadModel(QObject *parent)
    : QObject(parent), networkManager(new QNetworkAccessManager(this))
{

}

void UploadModel::uploadPost(const QString &filePath, const QString &caption)
{
    if (filePath.isEmpty() || caption.isEmpty()) {
        emit uploadFinished(false, "File or caption is missing.");
        return;
    }

    QUrl url("http://foodiez.vaskrneup.com/post/create/");
    QNetworkRequest request(url);

    if (!accessToken.isEmpty()) {
        request.setRawHeader("Authorization", "Bearer " + accessToken.toUtf8());
    }

    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    QString localPath = filePath;
    if (localPath.startsWith("file://")) {
        QUrl localUrl(localPath);
        localPath = localUrl.toLocalFile();
    }

    QFileInfo fileInfo(localPath);
    QFile *file = new QFile(localPath);
    if (!file->open(QIODevice::ReadOnly)) {
        emit uploadFinished(false, "Cannot open file: " + file->errorString());
        delete file;
        return;
    }

    // Guess MIME type
    QString suffix = fileInfo.suffix().toLower();
    QString mimeType = "application/octet-stream";
    if (suffix == "jpg" || suffix == "jpeg") mimeType = "image/jpeg";
    else if (suffix == "png") mimeType = "image/png";
    else if (suffix == "mp4") mimeType = "video/mp4";
    else if (suffix == "mov") mimeType = "video/quicktime";

    QHttpPart filePart;
    filePart.setHeader(QNetworkRequest::ContentDispositionHeader,
                       QVariant("form-data; name=\"files\"; filename=\"" + fileInfo.fileName() + "\""));
    filePart.setHeader(QNetworkRequest::ContentTypeHeader, mimeType);
    filePart.setBodyDevice(file);
    file->setParent(multiPart);

    // Caption part
    QHttpPart captionPart;
    captionPart.setHeader(QNetworkRequest::ContentDispositionHeader,
                          QVariant("form-data; name=\"caption\""));
    captionPart.setBody(caption.toUtf8());

    multiPart->append(filePart);
    multiPart->append(captionPart);

    QNetworkReply *reply = networkManager->post(request, multiPart);
    multiPart->setParent(reply);

    connect(reply, &QNetworkReply::uploadProgress, this, [=](qint64 sent, qint64 total) {
        emit uploadProgress(sent, total);
    });

    connect(reply, &QNetworkReply::finished, this, [=]() {
        onUploadFinished(reply);
    });
}

void UploadModel::onUploadFinished(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        emit uploadFinished(true, "Post uploaded successfully!");
    } else {
        QString errorStr = reply->errorString();
        qDebug() << "Upload error:" << errorStr;
        emit uploadFinished(false, "Upload failed: " + errorStr);
    }

    reply->deleteLater();
}

void UploadModel::setAccessToken(const QString &token)
{
    accessToken = token;
}
