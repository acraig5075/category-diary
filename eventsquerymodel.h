#ifndef EVENTSQUERYMODEL_H
#define EVENTSQUERYMODEL_H

#include <QSqlQueryModel>
#include <QDate>

class EventsQueryModel : public QSqlQueryModel
{
    Q_OBJECT
    Q_PROPERTY(QDate date READ date WRITE setDate)

public:
    const QString QueryFormatStr =
			"SELECT Events.myDate AS myDate, Events.percentage AS percent, Categories.description AS name, Events.id "
            "FROM Events "
            "INNER JOIN Categories ON Events.categoryId = Categories.id "
            "WHERE myDate >= '%1' AND myDate <= '%1' ";

	enum Roles { DateRole = Qt::UserRole + 1, PercentRole, NameRole, IdRole };

    EventsQueryModel(QObject *parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;

    QVariant data(const QModelIndex &index, int role) const override;

    QDate date() const;
    void setDate(const QDate &date);

public slots:
	int getId(int row);
	void update();

private:
    QDate m_date;
};

#endif
