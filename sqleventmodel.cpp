#include "sqleventmodel.h"

#include <QDebug>
#include <QFileInfo>
#include <QSqlError>
#include <QSqlQuery>

SqlEventModel::SqlEventModel(QObject *parent)
    : QObject(parent)
{
}

QList<QObject*> SqlEventModel::eventsForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1(
                "SELECT Events.myDate AS myDate, Events.percentage AS percent, Categories.description AS name "
                "FROM Events "
                "INNER JOIN Categories ON Events.categoryId = Categories.id "
                "WHERE '%1' >= myDate AND '%1' <= myDate").arg(date.toString("yyyy-MM-dd"));

    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("Query failed");

    QList<QObject*> events;
    while (query.next()) {
        Event *event = new Event(this);

        QDateTime date;
        date.setDate(query.value("myDate").toDate());
        event->setDate(date);
        event->setPercent(query.value("percent").toInt());
        event->setName(query.value("name").toString());

        events.append(event);
    }

    return events;
}
