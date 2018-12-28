#include <QSqlRecord>
#include "eventsquerymodel.h"

EventsQueryModel::EventsQueryModel(QObject *parent)
	: QSqlQueryModel(parent)
	, m_date(QDate::currentDate())
{
	update();
}

void EventsQueryModel::update()
{
	QString queryStr = QString(QueryFormatStr).arg(m_date.toString("yyyy-MM-dd"));

	setQuery(queryStr);
}

QHash<int, QByteArray> EventsQueryModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles[DateRole] = "date";
	roles[PercentRole] = "percent";
	roles[NameRole] = "name";
	roles[IdRole] = "id";
	return roles;
}

QVariant EventsQueryModel::data(const QModelIndex &index, int role) const
{
	QVariant value;

	if (index.isValid()) {
		if (role < Qt::UserRole) {
			value = QSqlQueryModel::data(index, role);
		} else {
			int columnIdx = role - Qt::UserRole - 1;
			QModelIndex modelIndex = this->index(index.row(), columnIdx);
			value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
		}
	}
	return value;
}

QDate EventsQueryModel::date() const
{
	return m_date;
}

void EventsQueryModel::setDate(const QDate &date)
{
	m_date = date;
	update();
}

int EventsQueryModel::getId(int row)
{
	return this->data(this->index(row, 0), IdRole).toInt();
}
