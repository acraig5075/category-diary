import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Controls 2.4

Item {
    anchors.fill: parent

    Text {
        id: text
        visible: false
    }

    FontMetrics {
        id: fontMetrics
        font.family: Flat.FlatStyle.fontFamily
    }

    readonly property int layoutSpacing: Math.round(5 * Flat.FlatStyle.scaleFactor)

    property var componentModel: [
        { name: "Diary", component: alasdairComponent },
        { name: "Categories", component: categoryComponent },
        { name: "Summary", component: summaryComponent },
    ]

    Loader {
        id: componentLoader
        anchors.fill: parent
        sourceComponent: componentModel[controlData.componentIndex].component
    }

    Component {
        id: categoryComponent
        Item {
            //enabled: !settingsData.allDisabled

            ListView {
                id: categoryView
                width: parent.width
                //anchors.fill: parent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: addCatButton.top
                anchors.margins: 10
                clip: true
                currentIndex: 0
                model: categoryModel

                delegate: MouseArea {
                    id: delegateItem
                    width: parent.width
                    height: 48 * Flat.FlatStyle.scaleFactor
                    onClicked: {
                        categoryView.currentIndex = index
                    }

                    Rectangle {
                        width: parent.width
                        height: Flat.FlatStyle.onePixel
                        anchors.bottom: parent.bottom
                        color: Flat.FlatStyle.lightFrameColor
                    }

                    Label {
                        text: model.name // was model.display
                        font.pixelSize: Math.round(15 * Flat.FlatStyle.scaleFactor)
                        font.family: Flat.FlatStyle.fontFamily
                        renderType: Text.QtRendering
                        color: delegateItem.ListView.isCurrentItem ? Flat.FlatStyle.styleColor : Flat.FlatStyle.defaultTextColor
                        anchors.left: parent.left
                        anchors.leftMargin: menuMargins
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    width: parent.height
                    height: 8 * Flat.FlatStyle.scaleFactor
                    rotation: 90
                    anchors.left: parent.right
                    transformOrigin: Item.TopLeft

                    gradient: Gradient {
                        GradientStop {
                            color: Qt.rgba(0, 0, 0, 0.15)
                            position: 0
                        }
                        GradientStop {
                            color: Qt.rgba(0, 0, 0, 0.05)
                            position: 0.5
                        }
                        GradientStop {
                            color: Qt.rgba(0, 0, 0, 0)
                            position: 1
                        }
                    }
                }
            }

            Button
            {
                id: addCatButton
                text: "Add"
                anchors.bottom: parent.bottom
                height:  48 * Flat.FlatStyle.scaleFactor
                anchors.margins: 10
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: inputDialog.open()

                Dialog {
                    id: inputDialog
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                    parent: Overlay.overlay

                    focus: true
                    modal: true
                    title: "Input"
                    standardButtons: Dialog.Ok | Dialog.Cancel

                    onAccepted: {
                        console.log("Current index is " + categoryView.currentIndex)
                        console.log("Corresponding table Id is " + categoryModel.data(categoryView.currentIndex, "id"))
                        database.addCategory(nameField.text)
                        categoryModel.update()
                    }

                    ColumnLayout {
                        spacing: 20
                        anchors.fill: parent
                        Label {
                            elide: Label.ElideRight
                            text: "Name:"
                            Layout.fillWidth: true
                        }
                        TextField {
                            id: nameField
                            focus: true
                            placeholderText: "New category name"
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }

    Component {
        id: alasdairComponent
        Item {
            //enabled: !settingsData.allDisabled

            Flow {
                id: row
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                layoutDirection: Qt.RightToLeft

                Calendar {
                    id: calendar
                    width: (parent.width > parent.height ? parent.width * 0.5 - parent.spacing : parent.width)
                    height: (parent.height > parent.width ? parent.height * 0.5 - parent.spacing : parent.height)
                    frameVisible: true
                    weekNumbersVisible: true
                    selectedDate: new Date()
                    focus: true

                    style: Flat.CalendarStyle {
                        dayDelegate: Item {
                            readonly property color sameMonthDateTextColor: "#444"
                            readonly property color selectedDateColor: Flat.FlatStyle.checkedAndPressedColor
                            readonly property color selectedDateTextColor: "white"
                            readonly property color differentMonthDateTextColor: "#bbb"
                            readonly property color invalidDatecolor: "#dddddd"

                            Rectangle {
                                anchors.fill: parent
                                border.color: "transparent"
                                color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                                anchors.margins: styleData.selected ? -1 : 0
                            }

                            Image {
                                id: dayDelegateImage
                                visible: styleData.visibleMonth && eventModel.eventsForDate(styleData.date).length > 0
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.margins: -1
                                width: 12
                                height: width
                                source: "qrc:/images/eventindicator.png"
                            }

                            Label {
                                id: dayDelegateText
                                text: styleData.date.getDate()
                                anchors.centerIn: parent
                                color: {
                                    var color = invalidDatecolor;
                                    if (styleData.valid) {
                                        // Date is within the valid range.
                                        color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                        if (styleData.selected) {
                                            color = selectedDateTextColor;
                                        }
                                    }
                                    color;
                                }
                            }
                        }
                    }
                }

                Component {
                    id: eventListHeader

                    Row {
                        id: eventDateRow
                        width: parent.width
                        height: eventDayLabel.height
                        spacing: 10

                        Label {
                            id: eventDayLabel
                            text: calendar.selectedDate.getDate()
                            font.pointSize: 35
                        }

                        Column {
                            height: eventDayLabel.height

                            Label {
                                readonly property var options: { weekday: "long" }
                                text: Qt.locale().standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
                                font.pointSize: 18
                            }
                            Label {
                                text: Qt.locale().standaloneMonthName(calendar.selectedDate.getMonth())
                                      + calendar.selectedDate.toLocaleDateString(Qt.locale(), " yyyy")
                                font.pointSize: 12
                            }
                        }
                    }
                }

                Rectangle {
                    width: (parent.width > parent.height ? parent.width * 0.5 - parent.spacing : parent.width)
                    height: (parent.height > parent.width ? parent.height * 0.5 - parent.spacing : parent.height)
                    border.color: Qt.darker(color, 1.2)

                    ListView {
                        id: eventsListView
                        spacing: 4
                        clip: true
                        header: eventListHeader
                        anchors.fill: parent
                        anchors.margins: 10
                        model: eventModel.eventsForDate(calendar.selectedDate)

                        delegate: Rectangle {
                            width: eventsListView.width
                            height: eventItemColumn.height
                            anchors.horizontalCenter: parent.horizontalCenter

                            Image {
                                anchors.top: parent.top
                                anchors.topMargin: 4
                                width: 12
                                height: width
                                source: "qrc:/images/eventindicator.png"
                            }

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: "#eee"
                            }

                            Column {
                                id: eventItemColumn
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.right: parent.right
                                height: timeLabel.height + nameLabel.height + 4

                                Label {
                                    id: nameLabel
                                    width: parent.width
                                    wrapMode: Text.Wrap
                                    text: modelData.name
                                    font.pointSize: 12
                                }
                                Label {
                                    id: timeLabel
                                    width: parent.width
                                    wrapMode: Text.Wrap
                                    text: modelData.percent + "%"
                                    color: "#aaa"
                                    font.pointSize: 10
                                }
                            }
                        }
                    }
                    Button
                    {
                        id:addEventButton
                        text:"Add"
                        anchors.bottom: parent.bottom
                        height:  48 * Flat.FlatStyle.scaleFactor
                        anchors.margins: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                        onClicked: inputDialog.open()

                        Dialog {
                            id: inputDialog
                            x: (parent.width - width) / 2
                            y: (parent.height - height) / 2
                            parent: Overlay.overlay

                            focus: true
                            modal: true
                            title: "Input"
                            standardButtons: Dialog.Ok | Dialog.Cancel

                            onAccepted: {
                                var categoryId = categoryModel.getId(categoryCombo.currentIndex)
                                console.log(qsTr("row: %1, id: %2").arg(categoryCombo.currentIndex).arg(categoryId))
                                var selectedDate = calendar.selectedDate
                                if (database.addEvent(selectedDate, categoryId)) {
                                    // redraw calendar

                                    // redraw eventsListView
                                    eventsListView.model = eventModel.eventsForDate(calendar.selectedDate)
                                }
                            }

                            ColumnLayout {
                                spacing: 20
                                anchors.fill: parent
                                Label {
                                    elide: Label.ElideRight
                                    text: "Category:"
                                    Layout.fillWidth: true
                                }
                                ComboBox {
                                    id: categoryCombo
                                    focus: true
                                    Layout.fillWidth: true
                                    model: categoryModel
                                    textRole: "name"
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: summaryComponent
        Flow {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            layoutDirection: Qt.LeftToRight

            Rectangle {
                id: topRect
                width: (parent.width > parent.height ? childrenRect.width : parent.width)
                height: (parent.height > parent.width ? childrenRect.height : parent.height)
                border.color: Qt.darker(color, 1.2)

                property int buttonSource: 0

                ColumnLayout {

                    Row {
                        padding: 10

                        Label {
                            text: "From"
                            font.pixelSize: 15
                            font.family: Flat.FlatStyle.fontFamily
                            renderType: Text.QtRendering
                            color: Flat.FlatStyle.styleColor
                        }
                        Button {
                            id: fromButton
                            text: fromButton.text=Qt.formatDate(fromCalendar.selectedDate, "dd-MM-yyyy");
                            onClicked: {
                                topRect.buttonSource = 1
                                calendarPopup.open()
                            }
                        }
                    }
                    Row {
                        padding: 10
                        topPadding: 0

                        Label {
                            text: "To"
                            font.pixelSize: 15
                            font.family: Flat.FlatStyle.fontFamily
                            renderType: Text.QtRendering
                            color: Flat.FlatStyle.styleColor
                        }
                        Button {
                            id: toButton
                            text: fromButton.text=Qt.formatDate(toCalendar.selectedDate, "dd-MM-yyyy");
                            onClicked: {
                                topRect.buttonSource = 2
                                calendarPopup.open()
                            }
                        }
                    }
                    Row {
                        padding: 10
                        topPadding: 0

                        Button {
                            id: queryButton
                            text: "Query"

                            onClicked: {
                                var fromDate = Qt.formatDate(fromCalendar.selectedDate, "yyyy-MM-dd");
                                var toDate = Qt.formatDate(toCalendar.selectedDate, "yyyy-MM-dd");
                                statsListView.model = statsModel.statsForDateRange(fromDate, toDate);
                            }
                        }
                    }

                }

                Popup {
                    id: calendarPopup
                    modal: true
                    focus: true
                    parent: Overlay.overlay

                    Calendar {
                        id: fromCalendar
                        visible: (topRect.buttonSource == 1)
                        selectedDate: new Date()
                        onClicked: {
                            fromButton.text=Qt.formatDate(fromCalendar.selectedDate, "dd-MM-yyyy");
                            calendarPopup.close()
                        }
                    }

                    Calendar {
                        id: toCalendar
                        visible: (topRect.buttonSource == 2)
                        selectedDate: new Date()
                        onClicked: {
                            toButton.text=Qt.formatDate(toCalendar.selectedDate, "dd-MM-yyyy");
                            calendarPopup.close()
                        }
                    }
                }
            }

            Rectangle {
                id: bottomRect
                width: (parent.width > parent.height ? parent.width - topRect.width - parent.spacing : parent.width)
                height: (parent.height > parent.width ? parent.height -topRect.height - parent.spacing : parent.height)
                border.color: Qt.darker(color, 1.2)

                ListView {
                    id: statsListView
                    width: parent.width
                    height: parent.height
                    anchors.fill: bottomRect
                    anchors.margins: 10
                    clip: true

                    delegate: Rectangle {
                        width: statsListView.width
                        height: statsItemColumn.height
                        anchors.horizontalCenter: parent.horizontalCenter

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: "#eee"
                        }

                        Column {
                            id: statsItemColumn
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.right: parent.right
                            height: descLabel.height + percentLabel.height + 4

                            Label {
                                id: descLabel
                                width: parent.width
                                wrapMode: Text.Wrap
                                text: modelData.description
                                font.pointSize: 10
                            }

                            Label {
                                id: percentLabel
                                width: parent.width
                                wrapMode: Text.Wrap
                                text: (modelData.percent).toFixed(0) + '%'
                                color: "#aaa"
                                font.pointSize: 10
                                anchors.right: parent.right
                            }
                        }
                    }
                }
            }
        }
    }
}
