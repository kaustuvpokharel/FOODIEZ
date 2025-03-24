import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../components"

Item {
    id: root
    width: parent.width
    height: parent.height

    Component.onCompleted:
    {
        postModel.fetchPosts()
    }

    BusyIndicator {
        running: postModel.loading
        visible: postModel.loading
        width: 40
        height: 40
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 200
        z: 999
    }

    // Stories data model
    property var stories: [
        { id: "1", name: "Your Story", avatar: "qrc:/avatar/Assets/images/default_avatar.png", hasStory: false },
        { id: "2", name: "Bhaskar Neupane", avatar: "qrc:/avatar/Assets/images/default_avatar.png", hasStory: true },
        { id: "3", name: "Sidhant Khati", avatar: "qrc:/avatar/Assets/images/default_avatar.png", hasStory: true },
        { id: "4", name: "Pradeep Katwal", avatar: "qrc:/avatar/Assets/images/default_avatar.png", hasStory: true }
    ]

    // // Posts data model - for testing
    // property var posts: [
    //     {
    //         id: "1",
    //         user: { name: "Dipak Khuswaha", avatar: "qrc:/avatar/Assets/images/default_avatar.png" },
    //         image: "qrc:/placeholders/Assets/images/placeholder.png",
    //         likes: 1234,
    //         comments: 56,
    //         caption: "Exploring new horizons 🌅 #adventure #photography",
    //         timestamp: "2h ago"
    //     },
    //     {
    //         id: "2",
    //         user: { name: "Sarika Khadka", avatar: "qrc:/avatar/Assets/images/default_avatar.png" },
    //         image: "qrc:/placeholders/Assets/images/placeholder.png",
    //         likes: 856,
    //         comments: 34,
    //         caption: "City lights and late nights 🌃 #urban #nightlife",
    //         timestamp: "4h ago"
    //     }
    // ]

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
                        source: "qrc:/logo/Assets/images/Foodiez.png"
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

            // Stories Section
            Rectangle {
                Layout.fillWidth: true
                height: 110
                color: "#121212"
                border.color: "#333333"
                border.width: 1

                ListView {
                    id: storiesListView
                    anchors.fill: parent
                    anchors.margins: 12
                    orientation: ListView.Horizontal
                    spacing: 20
                    model: stories

                    delegate: StoryItem {
                        storyData: modelData
                    }
                }
            }

            // Scrollable Post Section
            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
                currentIndex: postModel.loading ? 0 : 1

                // Placeholdea
                Column {
                    width: parent.width
                    spacing: 16
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    Repeater {
                        model: 3

                        delegate: Rectangle {
                            width: root.width * 0.9
                            height: 400
                            radius: 12
                            color: "#eeeeee"
                            opacity: 0.1
                            anchors.horizontalCenter: parent.horizontalCenter

                            // Blinking effect
                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                NumberAnimation { from: 0.1; to: 0.3; duration: 1200; easing.type: Easing.InOutQuad }
                                NumberAnimation { from: 0.3; to: 0.1; duration: 1200; easing.type: Easing.InOutQuad }
                            }
                        }
                    }
                }

                // Real Posts from postModel
                ListView {
                    id: postListView
                    spacing: 20
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: postModel

                    delegate: PostItem {
                        postData: ({
                            user: {
                                name: model.userName,
                                avatar: model.avatar
                            },
                            image: model.image,
                            likes: model.likes,
                            comments: model.comments,
                            caption: model.caption,
                            timestamp: model.timestamp
                        })
                    }
                }
            }
        }
    }
}
