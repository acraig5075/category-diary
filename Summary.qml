import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Controls 2.4

Component {
    Item {
        Flow {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10
            layoutDirection: Qt.LeftToRight

            Rectangle {
                id: topRect
                width: (parent.width > parent.height ? layout.width : parent.width)
                height: (parent.height > parent.width ? layout.height : parent.height)
                border.color: Qt.darker(color, 1.2)

                property int buttonSource: 0

                ColumnLayout {
                    id: layout

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
