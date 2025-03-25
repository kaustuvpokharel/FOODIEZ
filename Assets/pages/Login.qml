// @ author Kaustuv Pokharel
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects


Item {
    id: root
    width: parent.width
    height: parent.height

    signal loginSuccessful()
    //signal for sending the login has vbeen successful when the submit button is pushed

    property bool loading: false

    property string emailText: ""
    property string passwordText: ""

    Connections {
        target: Auth
        function onAuthResult(success) {
            loading = false;
            if (success) {
                errorMessage.text = "";
                root.loginSuccessful();
            } else {
                errorMessage.text = "Invalid email or password";
            }
        }
    }

    //loader until we land to the login page
    BusyIndicator {
        id: loader
        anchors.centerIn: parent
        running: root.loading
        visible: root.loading
        z: 1000
        width: 64
        height: 64
    }

    Rectangle
    {

        id:background
        anchors.fill: parent
        color: "#121212"
        Image
        {
            source: "qrc:/images/Assets/images/loginBg.jpg"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            opacity: 0.2
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "Transparent"

        ColumnLayout {
            width: parent.width * 0.85
            anchors.centerIn: parent
            spacing: 24

            // Title Text
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Taste the\nTrend"
                    color: "#ffffff"
                    font.pixelSize: 42
                    font.family: "pBold"
                    font.weight: 700
                }

                Text {
                    text: "Sign in to continue"
                    color: "#666666"
                    font.pixelSize: 16
                    font.family: "pMedium"
                    font.weight: 500
                }
            }

            // Form Inputs
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16

                // Email input field
                Rectangle {
                    Layout.fillWidth: true
                    height: 56
                    color: "#1A1A1A"
                    radius: 12
                    border.width: 1
                    border.color: "#333333"

                    RowLayout{
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Image {
                            source:"qrc:/icons/Assets/icons/mail.png"
                            width: 24
                            height: 24
                        }

                        TextField {
                            id: emailField
                            Layout.fillWidth: true
                            placeholderText: "Email"
                            color: "#ffffff"
                            placeholderTextColor:"#9C27B0"
                            font.pixelSize: 16
                            font.family: "pRegular"
                            font.weight: 400
                            onTextChanged: emailText = text
                            background: null
                        }
                    }
                }

                // Password input field
                Rectangle {
                    Layout.fillWidth: true
                    height: 56
                    color: "#1A1A1A"
                    radius: 12
                    border.width: 1
                    border.color: "#333333"

                    Row {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Image {
                            source: "qrc:/icons/Assets/icons/lock.png"
                            width: 24
                            height: 24
                        }

                        TextField {
                            id: passwordField
                            Layout.fillWidth: true
                            placeholderText: "Password"
                            color: "#ffffff"
                            placeholderTextColor: "#9C27B0"
                            font.pixelSize: 16
                            font.family: "pRegular"
                            font.weight: 400
                            echoMode: TextInput.Password
                            onTextChanged: passwordText = text
                            background: null
                        }
                    }
                }

                // Forgot password link
                Text {
                    text: "Forgot Password?"
                    color: "#9C27B0"
                    font.pixelSize: 14
                    font.family: "pMedium"
                    font.weight: 500
                    Layout.alignment: Qt.AlignRight
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: console.log("Forgot password clicked")
                    }
                }

                //Error to user
                Text {
                    id: errorMessage
                    text: ""
                    color: "#FF5252"
                    font.pixelSize: 14
                    visible: text.length > 0
                }

                // Sign In button with validation
                Rectangle {
                    Layout.fillWidth: true
                    height: 56
                    color: emailText.length > 8 && passwordText.length > 8 ? "#9C27B0" : "#444444"
                    radius: 12
                    Layout.topMargin: 8

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        enabled: emailText.length > 8 && passwordText.length > 8

                        onClicked: {
                            // loading = true;
                            // Auth.checkUser(emailText, passwordText);

                            ///Fort testing
                            root.loginSuccessful();
                        }
                    }
                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: "Sign In"
                            color: "#ffffff"
                            font.pixelSize: 16
                            font.family: "pBold"
                            font.weight: 700
                        }

                        Image {
                            source: "qrc:/icons/Assets/icons/arrow-right.png"
                            width: 16
                            height: 16
                            anchors.topMargin: -10
                        }
                    }
                }
            }

            // Social login options
            ColumnLayout {
                Layout.fillWidth: true
                Layout.topMargin: 32
                Layout.alignment: Qt.AlignHCenter
                spacing: 16

                Text {
                    text: "Or continue with"
                    color: "#666666"
                    font.pixelSize: 14
                    font.family: "pMedium"
                    font.weight: 500
                    Layout.alignment: Qt.AlignHCenter
                }

                // Social login buttons
                Row {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 16

                    // Google Login Button
                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: "#1A1A1A"
                        border.width: 1
                        border.color: "#333333"

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/icons/Assets/icons/google.png"
                            width: 24
                            height: 24
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: console.log("Google login clicked")
                        }
                    }

                    // Facebook Login Button
                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: "#1A1A1A"
                        border.width: 1
                        border.color: "#333333"

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/icons/Assets/icons/facebook.png"
                            width: 24
                            height: 24
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: console.log("Facebook login clicked")
                        }
                    }

                    // Apple Login Button
                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: "#1A1A1A"
                        border.width: 1
                        border.color: "#333333"

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/icons/Assets/icons/apple.png"
                            width: 24
                            height: 24
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: console.log("Apple login clicked")
                        }
                    }
                }
            }

            // Sign up link
            Row {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 32
                spacing: 4

                Text {
                    text: "Don't have an account?"
                    color: "#666666"
                    font.pixelSize: 14
                    font.family: "pMedium"
                    font.weight: 500
                }

                Text {
                    text: "Sign Up"
                    color: "#9C27B0"
                    font.pixelSize: 14
                    font.family: "pBold"
                    font.weight: 700

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: console.log("Sign up clicked")
                    }
                }
            }
        }
    }
}
