#include "Uploadmodel.h"
#include <QFileInfo>
#include <QHttpPart>
#include <QFile>
#include <QUrl>

UploadModel::UploadModel(QObject *parent)
    : QObject(parent), networkManager(new QNetworkAccessManager(this))
{}

void UploadModel::uploadPost(const QString &imagePath, const QString &caption)
{
    QUrl url("http://");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "multipart/form-data");

    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    // Image part
    QHttpPart imagePart;
    QFileInfo fileInfo(imagePath);
    QFile *file = new QFile(imagePath);
    if (!file->open(QIODevice::ReadOnly)) {
        emit uploadFinished(false, "Failed to open image file");
        delete file;
        multiPart->deleteLater();
        return;
    }

    imagePart.setHeader(QNetworkRequest::ContentDispositionHeader,
                        QVariant("form-data; name=\"image\"; filename=\"" + fileInfo.fileName() + "\""));
    imagePart.setHeader(QNetworkRequest::ContentTypeHeader, "image/jpeg");
    imagePart.setBodyDevice(file);
    file->setParent(multiPart);

    // Caption part
    QHttpPart captionPart;
    captionPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"caption\""));
    captionPart.setBody(caption.toUtf8());

    multiPart->append(imagePart);
    multiPart->append(captionPart);

    QNetworkReply *reply = networkManager->post(request, multiPart);
    multiPart->setParent(reply);

    connect(reply, &QNetworkReply::finished, this, [=]() {
        onUploadFinished(reply);
    });
}

void UploadModel::onUploadFinished(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        emit uploadFinished(true, "Post uploaded successfully.");
    } else {
        emit uploadFinished(false, reply->errorString());
    }
    reply->deleteLater();
}
