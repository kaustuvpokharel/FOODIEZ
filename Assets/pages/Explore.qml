import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "../components"

Item {
    id: root
    width: parent.width
    height: parent.height

    signal openPost(var postData)

    Component.onCompleted: exploreModel.fetchExploreImages()

    Rectangle {
        anchors.fill: parent

        color: "#121212"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                height: 80
                color: "#121212"
                border.color: "#333333"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Rectangle {
                        Layout.fillWidth: true
                        height: 48
                        radius: 12
                        color: "#1A1A1A"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            Image {
                                source: "qrc:/icons/Assets/icons/search.png"
                                width: 24
                                height: 24
                            }

                            TextField {
                                Layout.fillWidth: true
                                placeholderText: "Search"
                                placeholderTextColor: "#666666"
                                color: "#ffffff"
                                font.pixelSize: 16
                                background: null
                            }
                        }
                    }

                    Rectangle {
                        width: 48
                        height: 48
                        radius: 12
                        color: "#1A1A1A"

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/icons/Assets/icons/filter.png"
                            width: 24
                            height: 24
                        }
                    }
                }
            }

            StackLayout
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: exploreModel.count > 0 ? 1 : 0
                Layout.alignment: Qt.AlignHCenter

                GridView
                {
                    id: placeholderGrid
                    model: 8
                    width: parent.width
                    cellWidth: (parent.width/2)
                    cellHeight: cellWidth
                    interactive: false
                    clip: true

                    delegate: Rectangle
                    {
                        width: placeholderGrid.cellWidth
                        height: placeholderGrid.cellHeight
                        border.color: "#333333"
                        border.width: 2
                        color: "#eeeeee"
                        opacity: 0.1

                        SequentialAnimation on opacity
                        {
                            loops: Animation.Infinite
                            NumberAnimation { from: 0.1; to: 0.3; duration: 800 }
                            NumberAnimation { from: 0.3; to: 0.1; duration: 800 }
                        }
                    }
                }


                GridView
                {
                    id: gridView
                    model: exploreModel
                    cellWidth: width / 2
                    cellHeight: cellWidth
                    clip: true

                    delegate: Item
                    {
                        width: gridView.cellWidth
                        height: gridView.cellHeight

                        Rectangle
                        {
                            anchors.fill: parent
                            anchors.margins: 1
                            color: "#121212"

                            Image
                            {
                                anchors.fill: parent
                                source: model.imageUrl
                                fillMode: Image.PreserveAspectCrop
                            }

                            Rectangle
                            {
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                anchors.margins: 8
                                height: 24
                                width: likesText.width + 16
                                radius: 12
                                color: "#00000080"

                                Text
                                {
                                    id: likesText
                                    anchors.centerIn: parent
                                    text: model.likes + " likes"
                                    color: "#ffffff"
                                    font.pixelSize: 12
                                }
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.openPost({
                                        id: model.id,
                                        image: model.imageUrl,
                                        likes: model.likes,
                                        user: { name: "Unknown", avatar: "qrc:/avatar/Assets/images/default_avatar.png" },
                                        caption: "Explored post",
                                        comments: 0,
                                        timestamp: "Just now"
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
