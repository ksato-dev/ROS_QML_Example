import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Layouts 1.1

Window {
    ScrollView {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 55
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
        }
    }

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

    visible: true
    width: 360
    height: 360
}