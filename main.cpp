#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <Loginauthentication.h>
#include <Exploremodel.h>
#include <Postmodel.h>
#include <Uploadmodel.h>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //for LoginAuthetication Class
    LoginAuth auth;
    engine.rootContext()->setContextProperty("Auth", &auth);

    //for posts retrival
    PostModel postModel;
    engine.rootContext()->setContextProperty("postModel", &postModel);

    //for explore page
    ExploreModel exploreModel;
    engine.rootContext()->setContextProperty("exploreModel", &exploreModel);

    //for create page
    UploadModel uploadModel;
    engine.rootContext()->setContextProperty("uploadModel", &uploadModel);


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
