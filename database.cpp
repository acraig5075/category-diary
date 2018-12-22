#include <QDebug>
#include <QSqlQuery>
#include <QFile>
#include <QSqlError>
#include <QStandardPaths>
#include <QDate>
#include "database.h"
#include "stats.h"

Database::Database(QObject *parent)
    : QObject(parent)
{
}

bool Database::connect()
{
    QStringList dataLocations = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation);

    int i;
    for (i = 0; i < dataLocations.size(); ++i)
    {
        if (connectToDatabase(dataLocations[i] + "/db.sqlite"))
            return true;

        qDebug() << "... failed";\
    }

    if (i == dataLocations.size())
        qDebug() << "No database to work with, aborting...";
    return false;
}

bool Database::connectToDatabase(const QString &name)
{
    qDebug() << QString("Attempting to connect to ") + name;

    if (!QFile(name).exists())
        return create(name);
    else
        return open(name);
}

bool Database::open(const QString &name)
{
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(name);
    if (!m_db.open())
    {
        qDebug() << "Failed to open database: " << m_db.lastError();
        return false;
    }
    return true;
}

void Database::close()
{
    m_db.close();
}

bool Database::create(const QString &name)
{
    if (!open(name))
    {
        qDebug() << "Failed to create the database";
        return false;
    }

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS Categories (id INTEGER PRIMARY KEY, description TEXT NOT NULL)");
    query.exec("CREATE TABLE IF NOT EXISTS Events (id INTEGER PRIMARY KEY, myDate DATE NOT NULL, categoryId INT NOT NULL, percentage INT NOT NULL)");
    query.exec("INSERT INTO Categories (description) VALUES ('Default category')");
    return true;
}

bool Database::addCategory(const QString &name)
{
    QSqlQuery query;
    query.prepare("INSERT INTO Categories(description) VALUES(:Name)");
    query.bindValue(":Name", name);

    return query.exec();
}

bool Database::removeCategory(int id)
{
    QSqlQuery query;
    query.prepare("SELECT count(1) FROM Categories WHERE id = :Id");
    query.bindValue(":Id", id);

    if (!query.exec() || !query.next())
        return false;

    bool ok;
    int count = query.value(0).toInt(&ok);
    if (!ok || count != 0)
        return false;

    query.prepare("DELETE FROM Categories WHERE id = :Id");
    query.bindValue(":Id", id);
    return query.exec();
}

bool Database::renameCategory(int id, const QString &name)
{
    QSqlQuery query;
    query.prepare("UPDATE Categories SET description = :Name WHERE id = :Id");
    query.bindValue(":Name", name);
    query.bindValue(":Id", id);

    return query.exec();
}

bool Database::addEvent(const QDateTime &date, int categoryId)
{
    QString dateStr = date.toString("yyyy-MM-dd");
    QSqlQuery query;

    query.prepare("SELECT id FROM Categories WHERE id = :CategoryId");
    query.bindValue(":CategoryId", categoryId);

    if (!query.exec() || !query.next())
    {
        qDebug() << "Fail (1)" << query.lastError();
        return false;
    }

    query.prepare("INSERT INTO Events (myDate, categoryId, percentage) VALUES (:Date, :CategoryId, 100)");
    query.bindValue(":Date", dateStr);
    query.bindValue(":CategoryId", categoryId);

    if (!query.exec())
    {
        qDebug() << "Fail (2)" << query.lastError();
        return false;
    }

    query.prepare("SELECT count(1) FROM Events WHERE myDate = :Date");
    query.bindValue(":Date", dateStr);

    if (!query.exec() || !query.next())
    {
        qDebug() << "Fail (3)" << query.lastError();
        return false;
    }

    bool ok;
    int count = query.value(0).toInt(&ok);
    if (!ok)
    {
        qDebug() << "Fail (4)" << query.lastError();
        return false;
    }

    query.prepare("UPDATE Events SET percentage = :Percent WHERE myDate = :Date");
    query.bindValue(":Percent", 100 / count);
    query.bindValue(":Date", dateStr);

    if (!query.exec())
    {
        qDebug() << "Fail (5)" << query.lastError();
        return false;
    }

    return true;
}

int Database::eventsForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1(
                "SELECT COUNT(1) AS count "
                "FROM Events "
                "WHERE '%1' >= myDate AND '%1' <= myDate").arg(date.toString("yyyy-MM-dd"));

    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("Query failed");

    int count = 0;
    if (query.next())
    {
        count = query.value("count").toInt();
    }

    return count;
}

QList<QObject*> Database::summaryForDateRange(const QDate &fromDate, const QDate &toDate)
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
