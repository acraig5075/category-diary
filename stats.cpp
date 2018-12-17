#include "stats.h"

Stats::Stats(QObject *parent) :
    QObject(parent)
{
}

QString Stats::description() const
{
    return mDescription;
}

void Stats::setDescription(const QString &description)
{
    if (description != mDescription) {
        mDescription = description;
        emit descriptionChanged(mDescription);
    }
}

double Stats::percent() const
{
    return mPercent;
}

void Stats::setPercent(double percent)
{
    if (fabs(percent) - fabs(mPercent) > 0.0001) {
        mPercent = percent;
        emit percentChanged(mPercent);
    }
}
