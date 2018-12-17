#ifndef STATS_H
#define STATS_H

#include <QObject>
#include <QString>

class Stats : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(int percent READ percent WRITE setPercent NOTIFY percentChanged)

public:
    explicit Stats(QObject *parent = nullptr);

    QString description() const;
    void setDescription(const QString &description);

    double percent() const;
    void setPercent(double percent);

signals:
    void descriptionChanged(const QString &name);
    void percentChanged(double percent);

private:
    QString mDescription;
    double mPercent = 0.0;
};

#endif
