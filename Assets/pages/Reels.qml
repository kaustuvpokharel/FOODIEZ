import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../components"

Item {
    id: root
    width: parent.width
    height: parent.height
    // Reels data model
    // property var reelsData: [
    //     {
    //         id: "1",
    //         user: { name: "Kaustuv Pokharel", avatar: "qrc:/avatars/user1.jpg" },
    //         description: "Morning coffee routine ☕️ #lifestyle #coffee",
    //         song: "Lo-Fi Beats - Chill Music",
    //         likes: "423K",
    //         comments: "2,844",
    //         thumbnail: "qrc:/explore/image5.jpg"
    //     },
    //     {
    //         id: "2",
    //         user: { name: "Dipak", avatar: "qrc:/avatars/user1.jpg" },
    //         description: "City lights and vibes 🌃 #urban #nightlife",
    //         song: "Electronic Dreams - Night Drive",
    //         likes: "891K",
    //         comments: "5,123",
    //         thumbnail: "qrc:/explore/image6.jpg"
    //     }
    // ]
    Component.onCompleted:
    {

        reelModel.fetchReels()
    }

    Rectangle {
        anchors.fill: parent
        color: "#121212"

        // Header with title
        Rectangle {
            id: reelsHeader
            width: parent.width
            height: 60
            color: "transparent"
            z: 10

            Text {
                anchors.centerIn: parent
                text: "Reels"
                color: "#ffffff"
                font.pixelSize: 20
                font.family: "Inter"
                font.weight: Font.Bold
            }
        }

        // Reels swipe
        SwipeView {
            id: reelSwipeView
            anchors.fill: parent
            orientation: Qt.Vertical

            Repeater {
                model: reelModel

                delegate: ReelItem {
                    id: reelItem
                    reelData: model
                    isCurrent: reelSwipeView.currentIndex === index
                    Component.onCompleted: reelBecameActive()
                }
            }
        }
    }
}
