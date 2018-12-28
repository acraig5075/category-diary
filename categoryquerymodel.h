#ifndef CATEGORYQUERYMODEL_H
#define CATEGORYQUERYMODEL_H

#include <QSqlQueryModel>

class CategoryQueryModel : public QSqlQueryModel
{
	Q_OBJECT
public:
	const QString QueryStr =
			"SELECT c.id, c.Description, "
			"( "
			"SELECT COUNT(1) "
			"FROM Events AS e "
			"WHERE e.CategoryId = c.id "
			") AS usage "
			"FROM Categories AS c "
			"ORDER BY usage DESC ";

	enum Roles { IdRole = Qt::UserRole + 1, NameRole, UsageRole };

	CategoryQueryModel(QObject *parent = nullptr);

	QHash<int, QByteArray> roleNames() const override;

	QVariant data(const QModelIndex &index, int role) const override;

public slots:
	void update();
	int getId(int row);
	QString getName(int row);
};

#endif // CATEGORYQUERYMODEL_H
