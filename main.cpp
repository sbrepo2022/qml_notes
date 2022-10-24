#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFontDatabase>
#include <QQuickWindow>
#include "appcore.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    AppCore *app_core = new AppCore();
    QQmlContext *context = engine.rootContext();
    context->setContextProperty("appCore", app_core);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    QFontDatabase::addApplicationFont(":/fonts/Montserrat-Regular.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Montserrat-Light.ttf");

    return app.exec();
}
