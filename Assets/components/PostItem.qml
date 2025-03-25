import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    width: parent.width
    height: content.implicitHeight
    color: "#121212"

    property var postData: postData || {}

    Column{
        id: content
        anchors.fill: parent
        spacing: 8

        // Post Header (Profile + Name)
        Rectangle {
            width: parent.width
            height: 50
            color: "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                // Profile Image with Mask
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: "transparent"

                    Image {
                        id: profileImage
                        width: 36
                        height: 36
                        source: postData?.user?.avatar || "qrc:/avatar/Assets/images/default_avatar.png"
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: 36
                                height: 36
                                radius: 18
                            }
                        }
                    }
                }

                // User Name
                Text {
                    text: postData?.user?.name || "Unknown"
                    color: "#ffffff"
                    font.pixelSize: 14
                    font.family: "pBold"
                    font.weight: 700
                }

                Item { Layout.fillWidth: true }

                // More Options Button
                Image {
                    source: "qrc:/icons/Assets/icons/more-horizontal.png"
                    width: 24
                    height: 24
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: console.log("More options clicked")
                    }
                }
            }
        }

        // Post Image
        Rectangle {
            width: parent.width
            anchors.topMargin: -20
            height: 400

            color: "#1A1A1A"
            clip: true

            Image {
                anchors.fill: parent
                source: postData?.image || "qrc:/placeholders/Assets/images/placeholder.png"
                fillMode: Image.PreserveAspectCrop
            }
        }

        // **Action Buttons (Like, Comment, Share, Bookmark)**
        Row{
            width: parent.width
            height: 50
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            anchors.topMargin: -20
            spacing: 16

            Image {
                source: "qrc:/icons/Assets/icons/heart.png"
                width: 28
                height: 28
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Like clicked")
                }
            }

            Image {
                source: "qrc:/icons/Assets/icons/message-circle.png"
                width: 28
                height: 28
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Comment clicked")
                }
            }

            Image {
                source: "qrc:/icons/Assets/icons/share.png"
                width: 28
                height: 28
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Share clicked")
                }
            }

            Item { width: parent.width }

            Image {
                source: "qrc:/icons/Assets/icons/bookmark.png"
                width: 28
                height: 28
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Bookmark clicked")
                }
            }
        }

        // **Like Count**
        Text {
            anchors.leftMargin: 12
            anchors.topMargin: -10
            text: (postData?.likes || 0) + " likes"
            color: "#ffffff"
            font.pixelSize: 14
            font.weight: Font.Bold
        }

        // **Caption & Hashtags**
        Column {
            width: parent.width
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            anchors.topMargin: 10
            spacing: 2

            Text {
                text: postData?.user?.name || "Unknown"
                color: "#ffffff"
                font.weight: Font.Bold
                font.pixelSize: 14
            }

            Text {
                text: postData?.caption || ""
                color: "#ffffff"
                wrapMode: Text.Wrap
                width: parent.width - 24
            }
        }

        // **Try Me Button (Smaller & Positioned to the Right)**
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.topMargin: 10
            width: 80
            height: 32
            radius: 16
            color: "#8A2BE2"

            Text {
                anchors.centerIn: parent
                text: "Try Me"
                color: "#ffffff"
                font.pixelSize: 14
                font.weight: Font.Bold
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: console.log("Try Me clicked")
            }
        }
    }
}
