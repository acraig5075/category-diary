#include <QSqlRecord>
#include "categoryquerymodel.h"

CategoryQueryModel::CategoryQueryModel(QObject *parent)
	: QSqlQueryModel(parent)
{
	setQuery(QueryStr);
}

void CategoryQueryModel::update()
{
	setQuery(QueryStr);
}

// Getting the id of the row in the data view model
int CategoryQueryModel::getId(int row)
{
	return this->data(this->index(row, 0), IdRole).toInt();
}

QString CategoryQueryModel::getName(int row)
{
	return this->data(this->index(row, 0), NameRole).toString();
}

QHash<int, QByteArray> CategoryQueryModel::roleNames() const
{
	QHash<int, QByteArray> roles;
	roles[IdRole] = "id";
	roles[NameRole] = "name";
	roles[UsageRole] = "usage";
	return roles;
}

QVariant CategoryQueryModel::data(const QModelIndex &index, int role) const
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
