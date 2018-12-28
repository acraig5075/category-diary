import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2

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
                    eventsModel.date = date
                    eventsListView.currentIndex = -1
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
                    currentIndex: -1
                    model: eventsModel

                    delegate: MouseArea {
                        id: delegateItem
                        width: eventsListView.width
                        height: eventItemColumn.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            eventsListView.currentIndex = index
                        }

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
                                color: delegateItem.ListView.isCurrentItem ? Flat.FlatStyle.styleColor : Flat.FlatStyle.defaultTextColor
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

                        onPressAndHold: {
                            var pos = mapToItem(eventsListView, 0, height)
                            contextMenu.x = pos.x
                            contextMenu.y = pos.y
                            contextMenu.open()
                        }
                    }
                }

                RoundButton
                {
                    id:addEventButton
                    text: qsTr("+")
                    highlighted: true
                    height: 64
                    width: 64
                    radius: 32
                    anchors.margins: 10
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    onClicked: addEventDialog.open()
                }

            }

            Menu {
                id: contextMenu
                Label {
                    padding: 10
                    font.bold: true
                    width: parent.width
                    horizontalAlignment: Qt.AlignHCenter
                    text: "Menu"
                }
                MenuItem {
                    text: "Delete..."
                    onTriggered: {
                        confirmMessage.open()
                    }
                }
            }

            AddEventDialog {
                id: addEventDialog

                onFinished: {
                    var selectedDate = calendar.selectedDate
                    if (database.addEvent(selectedDate, categoryId)) {
                        eventsModel.date = selectedDate
                    }
                }
            }

            MessageDialog {
                id: confirmMessage
                title: "Confirm"
                text: "Are you sure you want to delete this diary event?"
                standardButtons: StandardButton.Yes | StandardButton.No
                onYes: {
                    var id = eventsModel.getId(eventsListView.currentIndex)
                    database.deleteEvent(id)
                    eventsModel.update()
                }
            }
        }
    }
}
