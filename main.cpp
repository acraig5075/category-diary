#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtGui/QFontDatabase>
#include <QtQml/QQmlContext>
#include <QDebug>

#include "database.h"
#include "sqleventmodel.h"
#include "categoryquerymodel.h"
#include "sqlstatsmodel.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    if (qgetenv("QT_QUICK_CONTROLS_1_STYLE").isEmpty()) {
#ifdef QT_STATIC
        // Need a full path to find the style when built statically
        qputenv("QT_QUICK_CONTROLS_1_STYLE", ":/ExtrasImports/QtQuick/Controls/Styles/Flat");
#else
        qputenv("QT_QUICK_CONTROLS_1_STYLE", "Flat");
#endif
    }

    Database database;
    if (!database.connect())
        qDebug() << "Cannot open or create database";

    CategoryQueryModel categoryModel;
    SqlEventModel eventModel;
    SqlStatsModel statsModel;

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    context->setContextProperty("categoryModel", QVariant::fromValue(&categoryModel));
    context->setContextProperty("eventModel", QVariant::fromValue(&eventModel));
    context->setContextProperty("statsModel", QVariant::fromValue(&statsModel));
    context->setContextProperty("database", QVariant::fromValue(&database));
    engine.load(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
