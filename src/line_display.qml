import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1

Window {

    Image {
        anchors.fill: parent
        source: "file:////home/ksato/dev/ros_rev/src/ROS_QML_Example/src/images/neko.png"
        sourceSize.width: width
        sourceSize.height: height

        ToolBar {
            RowLayout {
                anchors.fill: parent
                ToolButton {
                    text: qsTr("‹")
                    onClicked: stack.pop()
                }
                Label {
                    text: "Title"
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }
                ToolButton {
                    text: qsTr("⋮")
                    onClicked: menu.open()
                }
            }
        }

        Text {
            anchors.fill: parent

            // move center
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            // verticalAlignment: Text.AlignVCenter
            // horizontalAlignment: Text.AlignHCente
            // text: "FATAL ERROR"    // "error.string" とかで QObject 派生クラスのメンバを参照できるようにする。 
            text: qsTr(error_message.str)
            font.family: "Helvetica"
            font.pointSize: 24
            color: "red"

        }

    }

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: width * (3 / 5)
        anchors.topMargin: 300
        anchors.bottomMargin: 10
        color: "white"

    ScrollView {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        ListView {
            anchors.fill: parent

            model: mediator.strings
            delegate: Text {
                anchors.left: parent.left
                anchors.right: parent.right
                height: 25
                text: modelData
            }
            onContentYChanged: {
                positionViewAtEnd();
            }
            onContentHeightChanged: {
                positionViewAtEnd();
            }
        }
    }
    }
    visible: true
    width: 640
    height: 480
}