#ifndef EVENT_H
#define EVENT_H

#include <QDateTime>
#include <QObject>
#include <QString>

class Event : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(int percent READ percent WRITE setPercent NOTIFY percentChanged)

public:
    explicit Event(QObject *parent = nullptr);

    QString name() const;
    void setName(const QString &name);

    QDateTime date() const;
    void setDate(const QDateTime &startDate);

    int percent() const;
    void setPercent(int percent);

signals:
    void nameChanged(const QString &name);
    void dateChanged(const QDateTime &startDate);
    void percentChanged(int percent);

private:
    QString mName;
    QDateTime mDate;
    int mPercent = 100;
};

#endif
