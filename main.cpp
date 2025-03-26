#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <Loginauthentication.h>
#include <Exploremodel.h>
#include <Postmodel.h>
#include <Uploadmodel.h>
#include <Reelmodel.h>
#include <Profilemodel.h>
#include <QQmlContext>
#include <QSettings>

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

    //for reels
    ReelModel reelModel;
    engine.rootContext()->setContextProperty("reelModel", &reelModel);

    //for prolfile
    ProfileModel profileModel;
    engine.rootContext()->setContextProperty("profileModel", &profileModel);

    QSettings settings;
    QString savedToken = settings.value("accessToken").toString();
    if (!savedToken.isEmpty()) {
        postModel.setAccessToken(savedToken);
        postModel.fetchPosts();
    }

    // Save token after successful login
    QObject::connect(&auth, &LoginAuth::authResult, [&](bool success) {
        if (success)
        {
            QString token = auth.getAccessToken();
            settings.setValue("accessToken", token);               // Save token persistently
            postModel.setAccessToken(token);                      // Pass to postModel
            postModel.fetchPosts();
            profileModel.setAccessToken(token);
            profileModel.fetchUserProfile();
            uploadModel.setAccessToken(token);
        }
    });

    const QUrl url(u"qrc:/FOODIEZ/main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl)
        {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
