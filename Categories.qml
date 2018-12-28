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
            anchors.fill: parent
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
                onPressAndHold: {
                    var pos = mapToItem(categoryView, 0, height)
                    contextMenu.x = pos.x
                    contextMenu.y = pos.y
                    contextMenu.open()
                }

                Rectangle {
                    width: parent.width
                    height: Flat.FlatStyle.onePixel
                    anchors.bottom: parent.bottom
                    color: Flat.FlatStyle.lightFrameColor
                }

                Label {
                    text: model.name
                    font.pixelSize: Math.round(15 * Flat.FlatStyle.scaleFactor)
                    font.family: Flat.FlatStyle.fontFamily
                    renderType: Text.QtRendering
                    color: delegateItem.ListView.isCurrentItem ? Flat.FlatStyle.styleColor : Flat.FlatStyle.defaultTextColor
                    anchors.left: parent.left
                    anchors.leftMargin: menuMargins
                    anchors.verticalCenter: parent.verticalCenter
                }
                Label {
                    text: "(" + model.usage + ")"
                    font.pixelSize: Math.round(12 * Flat.FlatStyle.scaleFactor)
                    font.family: Flat.FlatStyle.fontFamily
                    font.italic: true
                    renderType: Text.QtRendering
                    color: "#bbb"
                    anchors.right: parent.right
                    anchors.rightMargin: menuMargins
                    anchors.verticalCenter: parent.verticalCenter
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
                    text: "Rename..."
                    onTriggered: {
                        var oldName = categoryModel.getName(categoryView.currentIndex);
                        renameDialog.renameCategory(oldName)
                    }
                }
                MenuItem {
                    text: "Delete..."
                }
            }

            RenameDialog {
                id: renameDialog

                onFinished: {
                    var id = categoryModel.getId(categoryView.currentIndex);
                    console.log("id = ", id, "newName = ", newName)
                    database.renameCategory(id, newName)
                    categoryModel.update()
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

        RoundButton {
            id: addCatButton
            text: qsTr("+")
            highlighted: true
            height: 64
            width: 64
            radius: 32
            anchors.margins: 10
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            onClicked: addCatDialog.open()
        }

        AddCategoryDialog {
            id: addCatDialog

            onFinished: {
                database.addCategory(name)
                categoryModel.update()
            }
        }
    }
}
