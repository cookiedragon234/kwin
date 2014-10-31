/*
 * Copyright 2014  Martin Gräßlin <mgraesslin@kde.org>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import QtQuick.Controls 1.2
import org.kde.kwin.private.kdecoration 1.0 as KDecoration

ScrollView {
    ListView {
        id: listView
        objectName: "listView"
        model: decorationsModel
        highlight: Rectangle {
            width: listView.width
            height: 150
            color: highlightColor
            opacity: 0.5
        }
        highlightMoveDuration: 250
        boundsBehavior: Flickable.StopAtBounds
        delegate: Item {
            width: listView.width
            height: 150
            KDecoration.Bridge {
                id: bridgeItem
                plugin: model["plugin"]
                theme: model["theme"]
            }
            KDecoration.Settings {
                id: settingsItem
                bridge: bridgeItem
            }
            KDecoration.Decoration {
                id: inactivePreview
                bridge: bridgeItem
                settings: settingsItem
                anchors.fill: parent
                Component.onCompleted: {
                    client.caption = Qt.binding(function() { return model["display"]; });
                    client.active = false;
                    anchors.leftMargin = Qt.binding(function() { return 40 - (inactivePreview.decoration.shadow ? inactivePreview.decoration.shadow.paddingLeft : 0);});
                    anchors.rightMargin = Qt.binding(function() { return 10 - (inactivePreview.decoration.shadow ? inactivePreview.decoration.shadow.paddingRight : 0);});
                    anchors.topMargin = Qt.binding(function() { return 10 - (inactivePreview.decoration.shadow ? inactivePreview.decoration.shadow.paddingTop : 0);});
                    anchors.bottomMargin = Qt.binding(function() { return 40 - (inactivePreview.decoration.shadow ? inactivePreview.decoration.shadow.paddingBottom : 0);});
                }
            }
            KDecoration.Decoration {
                id: activePreview
                bridge: bridgeItem
                settings: settingsItem
                anchors.fill: parent
                Component.onCompleted: {
                    client.caption = Qt.binding(function() { return model["display"]; });
                    client.active = true;
                    anchors.leftMargin = Qt.binding(function() { return 10 - (activePreview.decoration.shadow ? activePreview.decoration.shadow.paddingLeft : 0);});
                    anchors.rightMargin = Qt.binding(function() { return 40 - (activePreview.decoration.shadow ? activePreview.decoration.shadow.paddingRight : 0);});
                    anchors.topMargin = Qt.binding(function() { return 40 - (activePreview.decoration.shadow ? activePreview.decoration.shadow.paddingTop : 0);});
                    anchors.bottomMargin = Qt.binding(function() { return 10 - (activePreview.decoration.shadow ? activePreview.decoration.shadow.paddingBottom : 0);});
                }
            }
            MouseArea {
                hoverEnabled: false
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = index;
                }
            }
        }
    }
}
