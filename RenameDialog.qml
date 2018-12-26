import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1

Dialog {
    id: renameDialog
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    parent: Overlay.overlay

    focus: true
    modal: true
    title: "Rename Category"
    standardButtons: Dialog.Ok | Dialog.Cancel

    signal finished(string oldName, string newName)

    function renameCategory(oldName) {
        oldNameField.text = oldName
        renameDialog.open()
    }

    onAccepted: {
        finished(oldNameField.text, newNameField.text)
    }

    ColumnLayout {
        spacing: 20
        anchors.fill: parent
        Label {
            elide: Label.ElideRight
            text: "Old name:"
            Layout.fillWidth: true
        }
        TextField {
            id: oldNameField
            enabled: false
            Layout.fillWidth: true
        }
        Label {
            elide: Label.ElideRight
            text: "New name:"
            Layout.fillWidth: true
        }
        TextField {
            id: newNameField
            focus: true
            text: ""
            placeholderText: "New category name"
            Layout.fillWidth: true
        }
    }
}
