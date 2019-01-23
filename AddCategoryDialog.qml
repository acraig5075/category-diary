import QtQuick 2.6
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.4

Dialog {
    width: (parent.height > parent.width ? parent.width * 0.75 : parent.height * 0.75)
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    parent: Overlay.overlay

    focus: true
    modal: true
    title: "Add Category"
    standardButtons: Dialog.Ok | Dialog.Cancel

    signal finished(string name)

    onAccepted: {
        finished(nameField.text)
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
