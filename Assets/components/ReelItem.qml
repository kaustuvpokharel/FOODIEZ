import QtQuick
import QtMultimedia
import Qt5Compat.GraphicalEffects
import QtQuick.Controls

Item {
    id: reelItem
    property var reelData
    property bool isCurrent: true
    signal reelBecameActive()

    MediaPlayer {
        id: player
        source: reelData.videoUrl
        videoOutput: videoSurface
        audioOutput: AudioOutput {
            id: audio
            muted: true
        }

        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.LoadedMedia && isCurrent)
                play()
        }

        onErrorOccurred: console.error("Video error:", errorString)

        Component.onCompleted: {
            if (isCurrent) play()
        }
    }

    VideoOutput {
        id: videoSurface
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.3
    }

    Rectangle {
        id: playButton
        width: 60
        height: 60
        radius: 30
        color: "#80000000"
        anchors.centerIn: parent
        visible: player.playbackState === MediaPlayer.PausedState

        Image {
            anchors.centerIn: parent
            source: "qrc:/icons/Assets/icons/play.png"
            width: 30
            height: 30
        }
    }

    Rectangle {
        width: 40
        height: 40
        radius: 20
        color: "#80000088"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 16
        z: 99

        Image {
            anchors.centerIn: parent
            source: player.muted ? "qrc:/icons/mute.png" : "qrc:/icons/volume.png"
            width: 20
            height: 20
        }

        MouseArea {
            anchors.fill: parent
            onClicked: player.muted = !player.muted
        }
    }

    Column {
        anchors.right: parent.right
        anchors.bottom: descriptionArea.top
        anchors.margins: 16
        spacing: 20

        Column {
            spacing: 5
            Image {
                source: "qrc:/icons/Assets/icons/heart.png"
                width: 30
                height: 30
            }
            Text {
                text: reelData.likes
                color: "white"
                font.pixelSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Column {
            spacing: 5
            Image {
                source: "qrc:/icons/Assets/icons/message.png"
                width: 30
                height: 30
            }
            Text {
                text: reelData.comments
                color: "white"
                font.pixelSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Image {
            source: "qrc:/icons/Assets/icons/share.png"
            width: 30
            height: 30
        }

        Image {
            source: "qrc:/icons/Assets/icons/more-horizontal.png"
            width: 30
            height: 30
        }
    }

    Rectangle {
        id: descriptionArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 100
        color: "transparent"

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 8

            Row {
                spacing: 10
                Image {
                    source: reelData.avatar
                    width: 40
                    height: 40
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: 40
                            height: 40
                            radius: 20
                        }
                    }
                }
                Text {
                    text: reelData.userName
                    color: "white"
                    font.pixelSize: 16
                    anchors.verticalCenter: parent.verticalCenter
                }
                Rectangle {
                    width: 70
                    height: 30
                    color: "transparent"
                    border.color: "white"
                    border.width: 1
                    radius: 5
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "Follow"
                        color: "white"
                        font.pixelSize: 12
                    }
                }
            }

            Text {
                text: reelData.description
                color: "white"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Row {
                spacing: 8
                Image {
                    source: "qrc:/icons/Assets/icons/music.png"
                    width: 16
                    height: 16
                }
                Text {
                    text: reelData.song
                    color: "white"
                    font.pixelSize: 12
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (player.playbackState === MediaPlayer.PlayingState)
                player.pause()
            else
                player.play()
        }
    }

    Component.onCompleted: reelBecameActive.connect(() => {
        if (isCurrent)
            player.play()
        else
            player.pause()
    })
}
