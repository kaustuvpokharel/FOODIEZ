// StoryItem.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Item {
    width: 68
    height: 86
    property var storyData: null

    Rectangle {
        id: storyRing
        width: 68
        height: 68
        radius: 34
        color: storyData && storyData.hasStory ? "#9C27B0" : "#333333"

        Rectangle {
            anchors.centerIn: parent
            width: 60
            height: 60
            radius: 30
            color: "#121212"

            Image {
                anchors.fill: parent
                anchors.margins: 2
                source: storyData ? storyData.avatar : ""
                fillMode: Image.PreserveAspectCrop
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: 60
                        height: 60
                        radius: 30
                    }
                }
            }
        }
    }

    Text {
        anchors.top: storyRing.bottom
        anchors.topMargin: 4
        anchors.horizontalCenter: storyRing.horizontalCenter
        width: parent.width
        text: storyData ? storyData.name : ""
        color: "#ffffff"
        font.pixelSize: 12
        font.family: "Inter"
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: console.log("Story clicked:", storyData ? storyData.id : "unknown")
    }
}
