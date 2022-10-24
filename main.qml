import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Window 2.2
import QtGraphicalEffects 1.12

ApplicationWindow {
    id: app

    function mp(x) {
        return x * Screen.pixelDensity;
    }

    function saveData() {
        var jsonModel = [];
        for (var i = 0; i < notesModel.count; i++) {
            jsonModel.push(notesModel.get(i));
        }
        jsonData = JSON.stringify(jsonModel);
        appCore.saveFile("notes.json", jsonData);
    }

    function setData(text) {
        jsonData = text;
        if (jsonData) {
            notesModel.clear();
            var jsonModel = JSON.parse(jsonData);
            for (var i = 0; i < jsonModel.length; i++) {
                notesModel.append(jsonModel[i]);
            }
        }
    }

    property real textScale: 1.4

    visible: true
    color: "#eee"
    width: 1000
    height: 750
    title: qsTr("MyNotes")

    property string jsonData: ""

    Component.onCompleted: {
        appCore.openFile("notes.json");
    }

    onClosing: {
        saveData();
    }

    Connections {
        target: appCore
        onFileOpened: {
            setData(text);
        }
    }

    Text {
        id: emptyText
        anchors.centerIn: parent
        text: "Нет заметок"
        opacity: notesModel.count > 0 ? 0.0 : 1.0
        font.family: "Montserrat"
        font.pixelSize: mp(12)
        color: "#aaa"
    }

    ListModel {
        id: notesModel
    }

    ScrollView {
        anchors.fill: parent

        ListView {
            id: notesList
            width: parent.width
            spacing: mp(6)
            header: Item{ height: mp(6) }
            footer: Item{ height: mp(32) }
            model: notesModel

            delegate: Item {
                width: parent.width
                height: noteSurface.height

                FastShadow {
                    anchors.fill: noteSurface
                    radius: 26
                    borderRadius: noteSurface.radius
                    verticalOffset: 4
                    color: "#aaa"
                }

                Rectangle {
                    id: noteSurface
                    clip: true
                    color: "#fff"
                    radius: mp(6)
                    height: childrenRect.height
                    width: parent.width - mp(6) * 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    Column {
                        id: noteColumn
                        anchors.left: parent.left
                        anchors.right: toolsColumn.left
                        topPadding: mp(6)
                        bottomPadding: mp(6)
                        spacing: mp(6)
                        TextField {
                            id: noteHeaderField
                            anchors.left: parent.left
                            anchors.leftMargin: mp(6)
                            anchors.right: parent.right
                            clip: true
                            wrapMode: TextEdit.Wrap
                            selectByMouse: true
                            maximumLength: 100
                            font.family: "Montserrat"
                            font.pixelSize: mp(6) * textScale
                            text: noteHeader
                            placeholderText: "Название заметки..."
                            background: Rectangle {
                                anchors.fill: parent
                            }
                            onTextEdited: {
                                saveButton.opacity = 1.0;
                            }
                        }
                        TextArea {
                            id: noteTextField
                            anchors.left: parent.left
                            anchors.leftMargin: mp(6)
                            anchors.right: parent.right
                            clip: true
                            wrapMode: TextEdit.Wrap
                            selectByMouse: true
                            font.family: "Montserrat"
                            font.pixelSize: mp(4) * textScale
                            text: noteText
                            placeholderText: "Текст заметки..."
                            background: Rectangle {
                                anchors.fill: parent
                            }
                            onCursorPositionChanged: {
                                saveButton.opacity = 1.0;
                            }
                        }
                    }
                    Column {
                        id: toolsColumn
                        anchors.right: parent.right
                        width: 2 * mp(6) + childrenRect.width
                        topPadding: mp(6)
                        bottomPadding: mp(6)
                        leftPadding: mp(6)
                        rightPadding: mp(6)
                        spacing: mp(2)
                        Image {
                            id: deleteButton
                            width: mp(10)
                            height: width

                            source: "round-delete_forever-24px.svg"
                            sourceSize.width: width;
                            sourceSize.height: height;
                            smooth: true
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    deleteNoteWnd.deleteNoteNumber = index;
                                    deleteNoteWnd.yesCancel("Удалить заметку?");
                                }
                            }
                        }

                        Image {
                            id: saveButton
                            width: mp(10)
                            height: width

                            source: "round-save-24px.svg"
                            sourceSize.width: width;
                            sourceSize.height: height;
                            smooth: true

                            opacity: 0.0
                            Behavior on opacity {
                                NumberAnimation {duration: 200}
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    notesModel.setProperty(index, "noteHeader", noteHeaderField.text);
                                    notesModel.setProperty(index, "noteText", noteTextField.text);
                                    saveButton.opacity = 0.0;
                                }
                            }
                        }
                    }

                }
            }
        }
    }


    FastShadow {
        anchors.fill: addNoteButton
        radius: 40
        borderRadius: addNoteButton.radius
        verticalOffset: 8
        color: "#666"
    }

    Rectangle {
        Behavior on color {
            ColorAnimation {duration: 200}
        }

        id: addNoteButton
        color: "#fff"
        anchors.right: parent.right
        anchors.rightMargin: mp(8)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: mp(6)
        width: mp(20)
        height: mp(20)
        radius: mp(10)

        Image {
            source: "round-add-24px.svg"
            anchors.fill: parent
            anchors.margins: mp(2)
            sourceSize.width: width;
            sourceSize.height: height;
            smooth: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                notesModel.append({"noteHeader": "", "noteText": ""});
            }

            onPressed: {
                addNoteButton.color = "#eee";
            }

            onReleased: {
                addNoteButton.color = "#fff";
            }
        }
    }

    AlertDialog {
        property int deleteNoteNumber
        id: deleteNoteWnd
        textScale: app.textScale
        anchors.fill: parent
        onDialogResult: {
            if (result === 1) notesModel.remove(deleteNoteNumber);
        }
    }
}
