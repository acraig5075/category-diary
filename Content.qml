import QtQuick 2.6
import QtQuick.Layouts 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Controls 2.4

Item {
    anchors.fill: parent

    property var componentModel: [
        { name: "Diary", component: diary },
        { name: "Categories", component: categories },
        { name: "Summary", component: summary },
    ]

    Loader {
        id: componentLoader
        anchors.fill: parent
        sourceComponent: componentModel[controlData.componentIndex].component
    }

    Categories {
        id: categories
    }

    Diary {
        id: diary
    }

    Summary {
        id: summary
    }
}
