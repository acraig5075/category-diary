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

