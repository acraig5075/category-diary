#include "event.h"

Event::Event(QObject *parent) :
    QObject(parent)
{
}

QString Event::name() const
{
    return mName;
}

void Event::setName(const QString &name)
{
    if (name != mName) {
        mName = name;
        emit nameChanged(mName);
    }
}

QDateTime Event::date() const
{
    return mDate;
}

void Event::setDate(const QDateTime &date)
{
    if (date != mDate) {
        mDate = date;
        emit dateChanged(mDate);
    }
}

int Event::percent() const
{
    return mPercent;
}

void Event::setPercent(int percent)
{
    if (percent != mPercent) {
        mPercent = percent;
        emit percentChanged(mPercent);
    }
}
