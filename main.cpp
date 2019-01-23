#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtGui/QFontDatabase>
#include <QtQml/QQmlContext>
#include <QQuickStyle>
#include <QDebug>

#include "database.h"
#include "categoryquerymodel.h"
#include "eventsquerymodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Universal");

    Database database;
    if (!database.connect())
        qDebug() << "Cannot open or create database";

    CategoryQueryModel categoryModel;
    EventsQueryModel eventsModel;

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    context->setContextProperty("categoryModel", QVariant::fromValue(&categoryModel));
    context->setContextProperty("eventsModel", QVariant::fromValue(&eventsModel));
    context->setContextProperty("database", QVariant::fromValue(&database));
    engine.load(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
