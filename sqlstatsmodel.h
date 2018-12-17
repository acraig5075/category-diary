#ifndef SQLSTATSMODEL_H
#define SQLSTATSMODEL_H

#include <QList>
#include <QObject>

class SqlStatsModel : public QObject
{
    Q_OBJECT

public:
    SqlStatsModel(QObject *parent = nullptr);

    Q_INVOKABLE QList<QObject*> statsForDateRange(const QDate &fromDate, const QDate &toDate);
};

#endif
