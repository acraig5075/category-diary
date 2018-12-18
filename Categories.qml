import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat
import QtQuick.Controls 2.4

Component {
    Item {
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
