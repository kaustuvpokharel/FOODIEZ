#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <Loginauthentication.h>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //for LoginAuthetication Class
    LoginAuth auth;
    engine.rootContext()->setContextProperty("Auth", &auth);


    const QUrl url(u"qrc:/FOODIEZ/main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
