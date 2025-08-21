import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire


RippleButton {
    id: button
    required property bool input

    buttonRadius: Appearance.rounding.small
    colBackground: Appearance.colors.colLayer2
    colBackgroundHover: Appearance.colors.colLayer2Hover
    colRipple: Appearance.colors.colLayer2Active

    implicitHeight: contentItem.implicitHeight + 6 * 2
    implicitWidth: contentItem.implicitWidth + 6 * 2

    function nodeLabel(node) {
    if (!node) return null;
    // prefer built-ins; then fall back to properties dict
    return node.description
        || node.nickname
        || node.name
        || (node.properties ? (node.properties["node.description"] || node.properties["node.nickname"] || node.properties["node.name"]) : null);
    }

    Connections {
        target: Pipewire
        function onReadyChanged() {
            console.log("[Pipewire] ready ->", Pipewire.ready);
            console.log("[Pipewire] nodes count (if available):", Pipewire.nodes ? Pipewire.nodes.count : "n/a");
        }
        function onDefaultAudioSinkChanged() {
            const n = Pipewire.defaultAudioSink;
            console.log("[Pipewire] default sink changed:", n ? nodeLabel(n) : "null");
        }
        function onDefaultAudioSourceChanged() {
            const n = Pipewire.defaultAudioSource;
            console.log("[Pipewire] default source changed:", n ? nodeLabel(n) : "null");
        }
    }

    contentItem: RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        MaterialSymbol {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: false
            Layout.leftMargin: 5
            color: Appearance.colors.colOnLayer2
            iconSize: Appearance.font.pixelSize.hugeass
            text: input ? "mic_external_on" : "media_output"
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.rightMargin: 5
            spacing: 0
            StyledText {
                Layout.fillWidth: true
                elide: Text.ElideRight
                font.pixelSize: Appearance.font.pixelSize.normal
                text: input ? Translation.tr("Input") : Translation.tr("Output")
                color: Appearance.colors.colOnLayer2
            }
            StyledText {
                Layout.fillWidth: true
                elide: Text.ElideRight
                font.pixelSize: Appearance.font.pixelSize.smaller
                text: {
                    if (!Pipewire.ready) return Translation.tr("Audio (initializing…)");

                    const node = input ? Pipewire.defaultAudioSource : Pipewire.defaultAudioSink;
                    if (!node) return Translation.tr("Unknown");

                    // If you rely on properties dict, ensure the node is tracked/bound.
                    // (You already have PwObjectTracker { objects: [sink, source] }.)
                    const label = nodeLabel(node);
                    return label ?? Translation.tr("Unknown");
                }
                color: Appearance.m3colors.m3outline
            }
            // --- Deep diagnostics (prints to your terminal) ---
            Component.onCompleted: {
                console.log("Pipewire object:", Pipewire)
                console.log("Available keys:", Object.keys(Pipewire))
                console.log("[Pipewire] ready:", Pipewire.ready);
                if (Pipewire.nodes) {
                    console.log("[Pipewire] nodes count:", Pipewire.nodes.count);
                    for (var i = 0; i < Pipewire.nodes.count; i++) {
                        console.log("[Pipewire] node", i, ":", nodeLabel(Pipewire.nodes.get(i)));
                    }
                } else {
                    console.log("[Pipewire] nodes not available yet");
                }
            }


        }
    }
}
