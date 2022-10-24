import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Window 2.2
import QtGraphicalEffects 1.12

Rectangle {
    id: topRect
    function mp(x) {
        return x * Screen.pixelDensity;
    }

    property real textScale: 1.0
    signal dialogResult(int result) //0 - no, 1 - yes, 2 - cancel

    function yesNo(msgTxt) {
        messageText.text = msgTxt;
        topRect.visible = true;
        topRect.enabled = true;
        topRect.opacity = 1.0;

        yesButton.visible = true;
        noButton.visible = true;
    }

    function yesCancel(msgTxt) {
        messageText.text = msgTxt;
        topRect.visible = true;
        topRect.enabled = true;
        topRect.opacity = 1.0;

        yesButton.visible = true;
        cancelButton.visible = true;
    }

    function yesNoCancel(msgTxt) {
        messageText.text = msgTxt;
        topRect.visible = true;
        topRect.enabled = true;
        topRect.opacity = 1.0;

        yesButton.visible = true;
        noButton.visible = true;
        cancelButton.visible = true;
    }

    function sendResult(result) {
        topRect.opacity = 0.0;
        topRect.dialogResult(result);
    }

    color: "#aa000000"
    opacity: 0.0
    visible: false
    enabled: false

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            onRunningChanged: {
                if (running === false && topRect.opacity === 0.0) {
                    topRect.visible = false;
                    topRect.enabled = false;
                    yesButton.visible = false;
                    noButton.visible = false;
                    cancelButton.visible = false;
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            topRect.sendResult(2);
        }
    }

    Rectangle {
        anchors.centerIn: parent
        color: "#fff"
        radius: mp(6)
        width: childrenRect.width
        height: childrenRect.height
        Column {
            anchors.top: parent.top
            anchors.left: parent.left
            padding: mp(6)
            spacing: mp(6)

            Text {
                id: messageText
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Montserrat"
                font.pixelSize: mp(5) * topRect.textScale
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: mp(4)
                Rectangle {
                    Behavior on color {
                        ColorAnimation {duration: 200}
                    }

                    id: yesButton
                    visible: false
                    color: "#ddd"
                    width: yesRow.width
                    height: yesRow.height
                    radius: mp(4)
                    Row {
                        id: yesRow
                        padding: mp(3)
                        leftPadding: mp(6)
                        rightPadding: leftPadding
                        Text {
                            font.family: "Montserrat"
                            font.pixelSize: mp(4) * topRect.textScale
                            text: "Да"
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            topRect.sendResult(1);
                        }
                        onEntered: {
                            yesButton.color = "#ccc";
                        }
                        onExited: {
                            yesButton.color = "#ddd";
                        }
                    }
                }

                Rectangle {
                    Behavior on color {
                        ColorAnimation {duration: 200}
                    }

                    id: noButton
                    visible: false
                    color: "#ddd"
                    width: noRow.width
                    height: noRow.height
                    radius: mp(4)
                    Row {
                        id: noRow
                        padding: mp(3)
                        leftPadding: mp(6)
                        rightPadding: leftPadding
                        Text {
                            font.family: "Montserrat"
                            font.pixelSize: mp(4) * topRect.textScale
                            text: "Нет"
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            topRect.sendResult(0);
                        }
                        onEntered: {
                            noButton.color = "#ccc";
                        }
                        onExited: {
                            noButton.color = "#ddd";
                        }
                    }
                }

                Rectangle {
                    Behavior on color {
                        ColorAnimation {duration: 200}
                    }

                    id: cancelButton
                    visible: false
                    color: "#ddd"
                    width: cancelRow.width
                    height: cancelRow.height
                    radius: mp(4)
                    Row {
                        id: cancelRow
                        padding: mp(3)
                        leftPadding: mp(6)
                        rightPadding: leftPadding
                        Text {
                            font.family: "Montserrat"
                            font.pixelSize: mp(4) * topRect.textScale
                            text: "Отмена"
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            topRect.sendResult(2);
                        }
                        onEntered: {
                            cancelButton.color = "#ccc";
                        }
                        onExited: {
                            cancelButton.color = "#ddd";
                        }
                    }
                }
            }
        }
    }
}
