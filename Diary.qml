import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Controls 2.4

Component {
    Item {
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

                onClicked: {
                    // handler for click(date)
                    eventsModel.date = date
                }

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
                            visible: styleData.visibleMonth && database.eventsForDate(styleData.date) > 0
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

            Rectangle {
                width: (parent.width > parent.height ? parent.width * 0.5 - parent.spacing : parent.width)
                height: (parent.height > parent.width ? parent.height * 0.5 - parent.spacing : parent.height)
                border.color: Qt.darker(color, 1.2)

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

                ListView {
                    id: eventsListView
                    spacing: 4
                    clip: true
                    header: eventListHeader
                    anchors.fill: parent
                    anchors.margins: 10
                    model: eventsModel

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
                                text: model.name
                                font.pointSize: 12
                            }
                            Label {
                                id: timeLabel
                                width: parent.width
                                wrapMode: Text.Wrap
                                text: model.percent + "%"
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
                            var selectedDate = calendar.selectedDate

                            if (database.addEvent(selectedDate, categoryId)) {
                                eventsModel.date = selectedDate;
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
