#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSqlDatabase>


class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QObject *parent = nullptr);
    bool connect();

private:
    QSqlDatabase m_db;

private:
    bool connectToDatabase(const QString &name);
    bool open(const QString &name);
    void close();
    bool create(const QString &name);

public slots:
    bool addCategory(const QString &name);
    bool removeCategory(int id);
    bool renameCategory(int id, const QString &name);

    bool addEvent(const QDateTime &date, int categoryId);
};

#endif
