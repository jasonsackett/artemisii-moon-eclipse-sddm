import QtQuick 2.15

Rectangle {
    id: root
    width: screenModel.geometry(screenModel.primary).width
    height: screenModel.geometry(screenModel.primary).height
    color: "black"
    focus: true

    property int panelWidth: config.intValue("panelWidth") > 0 ? config.intValue("panelWidth") : 420
    property int panelHeight: config.intValue("panelHeight") > 0 ? config.intValue("panelHeight") : 520
    property int panelMargin: config.intValue("panelMargin") > 0 ? config.intValue("panelMargin") : 120
    property int panelRadius: config.intValue("panelRadius") > 0 ? config.intValue("panelRadius") : 18
    property int fieldHeight: config.intValue("fieldHeight") > 0 ? config.intValue("fieldHeight") : 46
    property int buttonHeight: config.intValue("buttonHeight") > 0 ? config.intValue("buttonHeight") : 46
    property real panelOpacity: config.realValue("panelOpacity") > 0 ? config.realValue("panelOpacity") : 0.30
    property real accentOpacity: config.realValue("accentOpacity") > 0 ? config.realValue("accentOpacity") : 0.10
    property real borderOpacity: config.realValue("borderOpacity") > 0 ? config.realValue("borderOpacity") : 0.18
    property color textColor: config.stringValue("textColor") !== "" ? config.stringValue("textColor") : "#f4f4f5"
    property color mutedTextColor: config.stringValue("mutedTextColor") !== "" ? config.stringValue("mutedTextColor") : "#b9bdc5"
    property color accentColor: config.stringValue("accentColor") !== "" ? config.stringValue("accentColor") : "#ffffff"
    property color borderColor: config.stringValue("borderColor") !== "" ? config.stringValue("borderColor") : "#ffffff"
    property color errorColor: config.stringValue("errorColor") !== "" ? config.stringValue("errorColor") : "#f38ba8"
    property string titleText: config.stringValue("title") !== "" ? config.stringValue("title") : "Artemis II"
    property string subtitleText: config.stringValue("subtitle") !== "" ? config.stringValue("subtitle") : "Sign in"
    property bool showPowerButtons: config.keys().indexOf("showPowerButtons") === -1 ? true : config.boolValue("showPowerButtons")
    property int sessionIndex: sessionModel.lastIndex
    property bool busy: false

    function effectiveUser() {
        if (usernameInput.text !== "") {
            return usernameInput.text
        }
        if (userModel.lastUser !== undefined && userModel.lastUser !== null) {
            return userModel.lastUser
        }
        return ""
    }

    function tryLogin() {
        errorText.text = ""
        var user = effectiveUser()
        if (user === "") {
            errorText.text = "Enter a username"
            usernameInput.forceActiveFocus()
            return
        }
        if (sessionIndex < 0) {
            errorText.text = "No valid session selected yet"
            return
        }
        busy = true
        sddm.login(user, passwordInput.text, sessionIndex)
    }

    Keys.onPressed: function(event) {
        if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && !busy) {
            tryLogin()
            event.accepted = true
        }
    }

    Image {
        id: background
        anchors.fill: parent
        source: "background.jpg"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        cache: false
    }

    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 12
        color: "#ff8080"
        font.pixelSize: 12
        visible: background.status !== Image.Ready
        text: "Background failed to load: " + background.source
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.12
    }

    Item {
        id: panel
        width: root.panelWidth
        height: root.panelHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: root.panelMargin
    }

    Item {
        anchors.fill: panel
        anchors.margins: 20

        Text {
            id: title
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            text: titleText
            color: textColor
            font.pixelSize: 22
            font.weight: Font.Light
            font.letterSpacing: 2
            elide: Text.ElideRight
        }

        Item {
            id: usernameField
            anchors.top: title.bottom
            anchors.topMargin: 32
            anchors.left: parent.left
            anchors.right: parent.right
            height: root.fieldHeight

            TextInput {
                id: usernameInput
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: TextInput.AlignVCenter
                color: textColor
                selectionColor: Qt.rgba(1, 1, 1, 0.25)
                selectedTextColor: textColor
                font.pixelSize: 15
                clip: true
                text: userModel.lastUser ? userModel.lastUser : ""
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier)) {
                        loginButton.forceActiveFocus()
                        event.accepted = true
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Tab) {
                        passwordInput.forceActiveFocus()
                        event.accepted = true
                    }
                }
            }

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                visible: usernameInput.text === "" && !usernameInput.activeFocus
                text: "username"
                color: mutedTextColor
                font.pixelSize: 15
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: usernameInput.activeFocus ? Qt.rgba(1, 1, 1, 0.7) : Qt.rgba(1, 1, 1, 0.25)
            }
        }

        Item {
            id: passwordField
            anchors.top: usernameField.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.right: parent.right
            height: root.fieldHeight

            TextInput {
                id: passwordInput
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: TextInput.AlignVCenter
                color: textColor
                selectionColor: Qt.rgba(1, 1, 1, 0.25)
                selectedTextColor: textColor
                font.pixelSize: 15
                echoMode: TextInput.Password
                passwordCharacter: "•"
                clip: true
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier)) {
                        usernameInput.forceActiveFocus()
                        event.accepted = true
                    } else if (event.key === Qt.Key_Tab) {
                        loginButton.forceActiveFocus()
                        event.accepted = true
                    } else if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && !busy) {
                        tryLogin()
                        event.accepted = true
                    }
                }
            }

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                visible: passwordInput.text === "" && !passwordInput.activeFocus
                text: "password"
                color: mutedTextColor
                font.pixelSize: 15
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: passwordInput.activeFocus ? Qt.rgba(1, 1, 1, 0.7) : Qt.rgba(1, 1, 1, 0.25)
            }
        }

        Text {
            id: capsText
            anchors.top: passwordField.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.right: parent.right
            visible: keyboard.capsLock
            text: "Caps Lock is on"
            color: mutedTextColor
            font.pixelSize: 13
        }

        Text {
            id: errorText
            anchors.top: capsText.visible ? capsText.bottom : passwordField.bottom
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.right: parent.right
            text: ""
            color: errorColor
            font.pixelSize: 13
            wrapMode: Text.Wrap
        }

        Item {
            id: loginButton
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: footerRow.top
            anchors.bottomMargin: 12
            height: root.buttonHeight
            focus: false
            activeFocusOnTab: false

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Tab && (event.modifiers & Qt.ShiftModifier)) {
                    passwordInput.forceActiveFocus()
                    event.accepted = true
                } else if (event.key === Qt.Key_Tab) {
                    usernameInput.forceActiveFocus()
                    event.accepted = true
                } else if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && !busy) {
                    tryLogin()
                    event.accepted = true
                }
            }

            Text {
                id: loginButtonText
                anchors.centerIn: parent
                text: busy ? "signing in..." : "sign in"
                color: busy ? mutedTextColor : textColor
                font.pixelSize: 14
                font.letterSpacing: 1.5
            }

            Rectangle {
                anchors.top: loginButtonText.bottom
                anchors.topMargin: 2
                anchors.horizontalCenter: parent.horizontalCenter
                width: loginButtonText.width
                height: 1
                color: Qt.rgba(1, 1, 1, 0.6)
                visible: loginButton.activeFocus
            }

            MouseArea {
                anchors.fill: parent
                enabled: !busy
                cursorShape: Qt.PointingHandCursor
                onClicked: tryLogin()
            }
        }

        Row {
            id: footerRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            spacing: 10

            Rectangle {
                visible: root.showPowerButtons && sddm.canReboot
                width: 96
                height: 34
                radius: 10
                color: Qt.rgba(1, 1, 1, 0.08)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.10)

                Text {
                    anchors.centerIn: parent
                    text: "Reboot"
                    color: mutedTextColor
                    font.pixelSize: 13
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.reboot()
                }
            }

            Rectangle {
                visible: root.showPowerButtons && sddm.canPowerOff
                width: 96
                height: 34
                radius: 10
                color: Qt.rgba(1, 1, 1, 0.08)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.10)

                Text {
                    anchors.centerIn: parent
                    text: "Power off"
                    color: mutedTextColor
                    font.pixelSize: 13
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.powerOff()
                }
            }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            busy = false
            passwordInput.text = ""
            errorText.text = "Login failed"
            passwordInput.forceActiveFocus()
        }
        function onLoginSucceeded() {
            busy = false
        }
    }

    Component.onCompleted: {
        if (usernameInput.text !== "") {
            passwordInput.forceActiveFocus()
        } else {
            usernameInput.forceActiveFocus()
        }
    }
}
