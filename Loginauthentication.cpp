#include "Loginauthentication.h"

LoginAuth::LoginAuth(QObject* parent)
{
    socket = new QTcpSocket(this);
}



/* Takes user credentials to send and check from the server
 *
 * @parem input email and password from user (passed inside qml)
 * @returns 'true' or 'false' after authentication
 */
void LoginAuth::checkUser(QString email, QString password)
{
    socket->connectToHost("IP place holder", 12345);
    //if connection doesn't happen in 3000millisecond
    if(!socket->waitForConnected(3000))
    {
        qDebug() << "Connection failed";
        emit authResult(false);
        return;
    }

    QString message = email + ":" + password;
    socket->write(message.toUtf8());

    if(!socket->waitForBytesWritten(2000))
    {
        qDebug() << "Write failed";
        emit authResult(false);
        return;
    }

    if(!socket->waitForReadyRead(3000))
    {
        qDebug() << "No response form the server";

        emit authResult(false);
        return;
    }

    QString response = QString::fromUtf8(socket->readAll().trimmed());

    if(response == "1")
    {
        emit authResult(true);
    }
    else
    {
        emit authResult(false);
    }

}

