import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../components"

Item {
    id: root
    width: parent.width
    height: parent.height

    // Stories data model
    property var stories: [
        { id: "1", name: "Your Story", avatar: "qrc:/avatars/user1.jpg", hasStory: false },
        { id: "2", name: "Bhaskar Neupane", avatar: "qrc:/avatars/user1.jpg", hasStory: true },
        { id: "3", name: "Sidhant Khati", avatar: "qrc:/avatars/user1.jpg", hasStory: true },
        { id: "4", name: "Pradeep Katwal", avatar: "qrc:/avatars/user1.jpg", hasStory: true }
    ]

    // Posts data model
    property var posts: [
        {
            id: "1",
            user: { name: "Dipak Khuswaha", avatar: "qrc:/avatars/user1.jpg" },
            image: "qrc:/explore/image1.jpg",
            likes: 1234,
            comments: 56,
            caption: "Exploring new horizons 🌅 #adventure #photography",
            timestamp: "2h ago"
        },
        {
            id: "2",
            user: { name: "Sarika Khadka", avatar: "qrc:/avatars/user1.jpg" },
            image: "qrc:/explore/image2.jpg",
            likes: 856,
            comments: 34,
            caption: "City lights and late nights 🌃 #urban #nightlife",
            timestamp: "4h ago"
        }
    ]

    Rectangle {
        anchors.fill: parent
        color: "#121212"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Header Section (Instagram-style title + icons)
            Rectangle {
                Layout.fillWidth: true
                height: 60
                color: "#121212"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    Image {
                        id: logo
                        source: "qrc:/logo/Foodiez.png"
                        height: 15
                        fillMode: Image.PreserveAspectFit
                    }

                    Item { Layout.fillWidth: true }

                    Image {
                        source: "qrc:/icons/Assets/icons/notification.png"
                        width: 24
                        height: 24
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: console.log("Notifications clicked")
                        }
                    }

                    Image {
                        source: "qrc:/icons/Assets/icons/message.png"
                        width: 24
                        height: 24
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: console.log("Messages clicked")
                        }
                    }
                }
            }

            // // Stories Section
            // Rectangle {
            //     Layout.fillWidth: true
            //     height: 110
            //     color: "#121212"
            //     border.color: "#333333"
            //     border.width: 1

            //     ListView {
            //         id: storiesListView
            //         anchors.fill: parent
            //         anchors.margins: 12
            //         orientation: ListView.Horizontal
            //         spacing: 16
            //         model: stories

            //         delegate: StoryItem {
            //             storyData: modelData
            //         }
            //     }
            // }

            // Scrollable Post Section
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                ColumnLayout {
                    width: parent.width
                    spacing: 20

                    Repeater {
                        model: posts

                        delegate: PostItem {
                            Layout.fillWidth: true
                            postData: modelData
                        }
                    }
                }
            }
        }
    }
}
