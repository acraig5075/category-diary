import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1

Dialog {
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    parent: Overlay.overlay

    focus: true
    modal: true
    title: "Add Event"
    standardButtons: Dialog.Ok | Dialog.Cancel

    signal  finished(int categoryId)

    onAccepted: {
        var categoryId = categoryModel.getId(categoryCombo.currentIndex)
        finished(categoryId)
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

