#include "sqlstatsmodel.h"
#include "stats.h"

#include <QDebug>
#include <QFileInfo>
#include <QSqlError>
#include <QSqlQuery>
#include <QDate>

SqlStatsModel::SqlStatsModel(QObject *parent)
    : QObject(parent)
{
}

QList<QObject*> SqlStatsModel::statsForDateRange(const QDate &fromDate, const QDate &toDate)
{
    QString fromDateStr = fromDate.toString("yyyy-MM-dd");
    QString toDateStr = toDate.toString("yyyy-MM-dd");

    QSqlQuery query;
    query.prepare("SELECT SUM(percentage) "
                  "FROM Events "
                  "WHERE :FromDate <= myDate "
                  "AND :ToDate >= myDate");
    query.bindValue(":FromDate", fromDateStr);
    query.bindValue(":ToDate", toDateStr);

    if (!query.exec() || !query.next())
    {
        qDebug() << "statsForDateRange::Fail (1)" << query.lastError();
        return {};
    }

    bool ok;
    int total = query.value(0).toInt(&ok);
    if (!ok)
    {
        qDebug() << "statsForDateRange::Fail (2)" << query.lastError();
        return {};
    }

    if (total == 0)
    {
        qDebug() << "0 rows returned";
        return {};
    }

    query.prepare("SELECT Categories.description AS desc, SUM(Events.percentage) * 100.0 / :Total AS percent "
                  "FROM Events "
                  "INNER JOIN Categories "
                  "ON Events.categoryId = Categories.id "
                  "WHERE :FromDate <= myDate "
                  "AND :ToDate >= myDate "
                  "GROUP BY categoryId "
                  "ORDER BY percent DESC ");
    query.bindValue(":Total", total);
    query.bindValue(":FromDate", fromDateStr);
    query.bindValue(":ToDate", toDateStr);

    if (!query.exec())
    {
        qDebug() << "statsForDateRange::Fail (3)" << query.lastError();
        return {};
    }

     QList<QObject*> stats;
     while (query.next())
     {
         Stats *stat = new Stats(this);
         stat->setDescription(query.value("desc").toString());
         stat->setPercent(query.value("percent").toDouble());
         stats.append(stat);
     }

    return stats;
}
